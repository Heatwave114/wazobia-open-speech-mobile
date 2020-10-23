# Core
import os
# External
from pydub import AudioSegment
from pydub.silence import split_on_silence


def match_target_amplitude(aChunk, target_dBFS):
    ''' Normalize given audio chunk '''
    change_in_dBFS = target_dBFS - aChunk.dBFS
    return aChunk.apply_gain(change_in_dBFS)


def segment_on_silence(directory='wazobia'):
    for subdir, dirs, files in os.walk(directory):
        for f in files:
            if f.endswith('.flac'):
                flac_file_path = os.path.join(subdir, f)
                sound_name = f.split('.')[0]
                sound = AudioSegment.from_file(
                    file=flac_file_path, format='flac')
                chunks = split_on_silence(
                    sound, min_silence_len=900, silence_thresh=-30)
                f_chunks_dir = os.path.join(subdir, sound_name + '__chunks')
                if not os.path.exists(f_chunks_dir) and len(chunks) > 0:
                    os.mkdir(f_chunks_dir)
                print(f_chunks_dir)
                for i, chunk in enumerate(chunks):
                    silence_chunk = AudioSegment.silent(duration=500)
                    audio_chunk = silence_chunk + chunk + silence_chunk
                    normalized_chunk = match_target_amplitude(audio_chunk, -20.0)
                    f_chunk = os.path.join(
                        f_chunks_dir, sound_name + '__chunk__{0}'.format(i)) + '.flac'
                    print('Exporting:', os.path.basename(f_chunk))
                    if not os.path.exists(f_chunk):
                        normalized_chunk.export(
                            f_chunk,
                            format="flac"
                        )
                    print(os.path.basename(f_chunk))
    print('segmentation successful!')


segment_on_silence('test')
