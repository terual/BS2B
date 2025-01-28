# Bauer stereophonic-to-binaural DSP plugin for Lyrion Music Server 

See https://forums.lyrion.org/forum/user-forums/3rd-party-software/1750004-announce-bauer-stereophonic-to-binaural-dsp-plugin for instruction how to install and use.

### About bs2bconvert instead of bs2bstream

This plugin uses the bs2bconvert binary of the 3.1.0 release of libbs2b with a small patch applied to output all error information to stderr instesd of stdout. I chose the bs2bconvert binary instead of the bs2bstream binary (which is intended for stdin-stdout pipelines) to avoid passing in all the parameters of the stream (bit depth, sample rate, etc.). When using the AU format all these parameters are encapsulated in the stream and the transcoding pipeline stays simpler. The downside is that the standard bs2bconvert binary outputs error information into the stdout stream which conflicts when also using stdout for the audio stream, hence the small patch.
