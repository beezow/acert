#!/usr/bin/env python3
import ffmpeg
import argparse
import os
import sys
import numpy as np

from tqdm import tqdm
from enzyme import MKV
from Crypto.Hash import SHA256
from Crypto.PublicKey import RSA
from Crypto.Signature import pkcs1_15
from Crypto import Random

from moviepy.editor import *


def clip(in_file, start, end):
    v = load_video(in_file)
    
    end = end if end < v.end else v.end
    start = start if start < v.start else v.start
    start_frame = int((start/v.duration) * v.reader.nframes)
    end_frame = int((end/v.duration) * v.reader.nframes)
    start = v.duration * start_frame/v.reader.nframes
    end = v.duration * end_frame/v.reader.nframes

    print("start: {}\nend: {}".format(start_frame, end_frame))
    sig = load_sig_from_vid(in_file)
    sig = sig[start_frame:end_frame]
    print(sig[0])
    ffmpeg.input(in_file).trim(start_frame=start_frame, end_frame=end_frame).setpts ('PTS-STARTPTS').output(".int.mkv", acodec='copy', vcodec='copy')

    add_signature(".int.mkv", sig)

def add_signature(in_file, signature):
    hash = ''
#    signature=signature[0:1]
 #   print(signature[0].tobytes().hex())
    for i, s in enumerate(tqdm(signature)):
        hash += signature[i].tobytes().hex()


    metadata = "acert_hash={}".format(hash)
    with open(".tmphash", 'w') as f:
        f.write(metadata)

    os.system('./add_meta.sh {}'.format(in_file))
#    add_metahash_data(in_file, in_file[:-4]+"signed.mkv", metadata)

def add_metahash_data(in_file, out_file,  metadata):
    ffmpeg.input(in_file).output(out_file, acodec='copy', vcodec='copy', metadata=metadata).run()

def load_sig_from_vid(infile):
    try:
        hex = meta_load_hexsignature(infile)
        sig_b = bytes.fromhex(hex)
        sig = np.frombuffer(sig_b).reshape(-1, 32)
        return sig
    except:
        print("Invalid")
        sys.exit(2)

def meta_load_hexsignature(in_file):
    with open(in_file, 'rb') as f:
        vid_meta = MKV(f)
    str_tags = str(vid_meta.tags[0])
    start = str_tags.find("ACERT_HASH")+47
    hex_sig = ""
 #   wprint("deat")
    while str_tags[start] != ']':
        hex_sig += str_tags[start]
        start += 1
        
#    print(hex_sig)
    return hex_sig


def gen_hash(frame):
    hash = SHA256.new();
#    for b in frame.ravel():
    hash.update(frame.tobytes())
    return hash

def sign_frame(frame, key):
    hash = gen_hash(frame)
#    print(hash.digest())
    return pkcs1_15.new(key).sign(hash)

def verify_frame(pk, frame, signature):
#    for frame in video.iter_frames():
    hash = gen_hash(frame)
    try:
        pk.verify(hash, signature.tobytes())
        return True;
    except (ValueError, TypeError):
        return False


def sign_clip(video, key):
    agr_sign = np.zeros((int(video.reader.nframes),32))
    for i, frame in enumerate(tqdm(video.iter_frames())):
#        agr_sign[i] = sign_frame(frame, key))
        agr_sign[i] =  np.frombuffer(sign_frame(frame, key))
    #print(agr_sign[0])
    return agr_sign


def verify_clip(video, key, signature):
    pk = pkcs1_15.new(key)
    #print(signature[0])
    try:
        for i, frame in enumerate(tqdm(video.iter_frames())):
            pa = verify_frame(pk, frame, signature[i])
            if (not pa):
                print("Invalid {}".format(i))
                return
    except:
        print("Invalid")
        return

    print("Valid")


def load_video(vid_file):
    return VideoFileClip(vid_file)

def load_key(key_file):
    with open(key_file, "r") as key:
        return RSA.importKey(key.read().strip())

def load_sig(sig_file):
    with open(sig_file, "rb") as f:
        return np.frombuffer(f.read()).reshape((-1,32))

'''
ex:
'''
if __name__ == "__main__":
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, epilog='''Example Usage:
        \nclipsign.py testmp4.mp4 --sign --key private.rsa --signature test.sig \
        \nclipsign.py testmp4.mp4 --sign --key private.rsa  \
        \nclipsign.py check signed.mp4 --key public.rsa \
        \nclipsign.py check signed.mp4 --key public.rsa --signature test.sig \
        \nclipsign.py clip signed.mp4 --start 1 --end 10 \
    ''');

    parser.add_argument('infile', help="input mp4 file")
    parser.add_argument('--key', help="file holding rsa public/private key")
    parser.add_argument('--signature', help="file holding signature")
    parser.add_argument('--clip', help="clip the video segment to given times", action="store_true")
    parser.add_argument('--start', help="clip the video segment from start time to end time", type=int)
    parser.add_argument('--end', help="clip the video segment from start time to end time", type=int)
    parser.add_argument('--check', help="check the video segments validity", action="store_true")
    parser.add_argument('--sign', help="sign the video with the given private key", action="store_true")

    args = parser.parse_args();
    if args.clip:
        clip(args.infile, args.start, args.end)
    elif args.sign:
        sig = sign_clip(load_video(args.infile), load_key(args.key))
        add_signature(args.infile, sig)
        if args.signature:
          with open(args.signature, "wb") as f:
                f.write(sig.tobytes())

    elif args.check:
        if args.signature:  
            verify_clip(load_video(args.infile), load_key(args.key), load_sig(args.signature))
        else:
            verify_clip(load_video(args.infile), load_key(args.key), load_sig_from_vid(args.infile))
