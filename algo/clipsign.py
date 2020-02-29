import ffmpeg
import argparse
import numpy as np

from moviepy.editor import *

from tqdm import tqdm
from Crypto.Hash import SHA256
from Crypto.PublicKey import RSA
from Crypto.Signature import pkcs1_15
from Crypto import Random

def clip(video, start, end):
    end = end if end < video.end else video.end
    start = start if start < video.start else video.start
    return video.subclip(start, end)

def add_signature(in_file, signature):
    hash = str(signature.tobytes())
    metadata = "acert_hash={}".format(hash)
    add_metahash_data(in_file, in_file, metadata)
    
def add_metahash_data(in_file, out_file,  metadata):
    ffmpeg.input(in_file).output(out_file, metadata=metadata).run()

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
        return False;


def sign_clip(video, key):
    agr_sign = np.zeros((video.reader.nframes,32))
    for i, frame in enumerate(tqdm(video.iter_frames())):
#        agr_sign[i] = sign_frame(frame, key))
        agr_sign[i] =  np.frombuffer(sign_frame(frame, key))
 #   print(agr_sign[0])
    return agr_sign


def verify_clip(video, key, signature):
#    signature = np.zeros((video.reader.nframes,32))
    pk = pkcs1_15.new(key)
#    print(signature[0])
    for i, frame in enumerate(tqdm(video.iter_frames())):
        pa = verify_frame(pk, frame, signature[i])
        if (not pa):
            print("fail {}".format(i))
            return

    print("pass")


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
    parser = argparse.ArgumentParser()
    '''
        clipsign.py sign testmp4.mp4 --outfile testsigned.mp4 --private-key private.rsa \
        clipsign.py sign testmp4.mp4 --private-key private.rsa \
        clipsign.py check signed.mp4 --public-key public.rsa \
        clipsign.py clip signed.mp4 --start 1 --end 10 --outfile stillsigned.mp4 \
    '''
    parser.add_argument('infile', help="input mp4 file")
    parser.add_argument('--outfile', help="output mp4 file")
    parser.add_argument('--key', help="file holding rsa public/private key")
    parser.add_argument('--sig', help="file holding signature")
    parser.add_argument('--clip', help="clip the video segment to given times", action="store_true")
    parser.add_argument('--start', help="clip the video segment from start time to end time")
    parser.add_argument('--end', help="clip the video segment from start time to end time")
    parser.add_argument('--check', help="check the video segments validity", action="store_true")
    parser.add_argument('--sign', help="sign the video with the given private key", action="store_true")

    args = parser.parse_args();
    if args.clip:
        pass
    elif args.sign:
        with open(args.sig, "wb") as f:
            sig = sign_clip(load_video(args.infile), load_key(args.key))
            f.write(sig.tobytes())
#            add_signature(args.infile, sig)
    elif args.check:
        verify_clip(load_video(args.infile), load_key(args.key), load_sig(args.sig))
