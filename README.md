# ACERT

## Inspiration
55% of all Americans get their news online, according to Pew Research, 8% more than last year. With the tremendous rise in the perceived legitimacy of this new source, social media platforms have struggled to ensure credibility. One of social media’s strengths is its low barrier to entry, but this strength makes it vulnerable to disinformation campaigns. The Knight Foundation discovered more than 6 million false Tweets posted just over the course of the month before the 2016 election.

We wanted to develop an extendable, open tool to help social media platforms combat disinformation.

One dangerous source of misinformation is fake videos designed to look credible. Deepfakes fall under this category alongside more traditional manipulations of content. These manipulations give the appearance that someone (typically a public figure) did/said something they never did. A video of House Speaker Nancy Pelosi was widely shared among the highest levels of government, giving the impression she was intoxicated in an interview. 

These disinformation campaigns leverage the credibility of the original source. The modified video of the Speaker of the House appeared to be a normal C-SPAN interview, allowing it to spread so widely and quickly. There was no way to know whether a posted video was real or fake, because all embedded videos are treated the same on a social media platform like Twitter.

This is an important problem a number of groups are actively trying to solve, including the platforms themselves.  However, most approach the problem as a constant, massive game of whack-a-mole: find fake videos as they are posted and delete them. We chose an additive approach. Rather than try to identify fake videos, we developed a tool to highlight real ones. 

We developed a video hashing method stored in the metadata of a video file that allows content creators to verify versions of their videos, no matter who posts them. 

## How it works
Suppose C-SPAN films a video of a Senator doing an interview. Often, they share clips of those interviews on Twitter. Their workflow today is simple: get the raw video file, log onto the official Twitter account, and post the video. The video gets copied and reposted hundreds of thousands of times by users benign and malicious. This is where misinformation thrives, because any copy of the video is treated identically from Twitter, from any source other than C-SPAN itself.

Our platform has two components. The first is a video hashing tool. The second is an open source interface for social media platforms to support video verification. We also built a social media app to demonstrate the full workflow.

C-SPAN uses the video hashing tool on their video. We use our multi-granularity geometric robust video sequencing hash algorithm. We derived this from a paper from Chen, Wo, Han, adding the canonical query sequence hashing used in audio processing. The hashing algorithm is robust, maintaining integrity over, while also sensitive to illegal operations such as changing colors or adding/subtracting pixels.

The video hashing program then uses C-SPAN's existing SSL certificate’s private key to encrypt the video hash and stores it in the metadata of the video MKV/MP4 file. This is done once, taking ~30 seconds per minute of video. Now, C-SPAN posts the video normally. 

The hashing algorithm is written as a Python, which we’ve uploaded to PyPi, an open-source repository for packages.

The second component of our project is an open-source tool for social media platforms. Acert_video is a package in Flutter, which is deployable to Pub.dev, an open-source repository for Flutter packages. It wraps around video_player, an open source video playback tool, and requires a URL to an MP4 to verify it. The verification process works like this (we use Twitter as our sample social media):
1. C-SPAN posts a video to Twitter normally.
2. Twitter sees that the video has an encrypted hash in its metadata.
3. Twitter connects to its backend (we implemented a backend with Google Cloud) with the video id and the hash.
4. The backend server gets the public SSL of the supposed verifier. It decrypts the provided hash using the public key and hashes the video. If the two match, it’s a verified video!
5. That verification process is done once when posting, so there is no impact on the user who watches the video-- that info is cached.
6. Verified videos are “blue checked” every time a user sees them.

