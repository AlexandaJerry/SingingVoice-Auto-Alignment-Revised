import os

# Create csv directory
def create_directories():
    slice_path = './ready_for_slice'

    if not os.path.exists(slice_path):
        try:
            os.mkdir(slice_path)
        except OSError:
            print('Creation of directory %s failed' %slice_path)

    sliced_audio = './sliced_audio'

    if not os.path.exists(sliced_audio):
        try:
            os.mkdir(sliced_audio)
        except OSError:
            print('Creation of directory %s failed' %sliced_audio)

    merged_csv_files = './merged_csv'

    if not os.path.exists(merged_csv_files):
        try:
            os.mkdir(merged_csv_files)
        except OSError:
            print('Creation of directory %s failed' %merged_csv_files)

    final_csv_files = './final_csv'

    if not os.path.exists(final_csv_files):
        try:
            os.mkdir(final_csv_files)
        except OSError:
            print('Creation of directory %s failed' %final_csv_files)

    my_wavs = './my_wavs'

    if not os.path.exists(my_wavs):
        try:
            os.mkdir(my_wavs)
        except OSError:
            print('Creation of directory %s failed' %my_wavs)

    my_lyrics = "./my_lyrics/"
    if not os.path.exists(my_lyrics):
        try:
            os.mkdir(my_lyrics)
        except OSError:
            print('Creation of directory %s failed' %my_lyrics)

    my_textgrid = './my_textgrid'
    if not os.path.exists(my_textgrid):
        try:
            os.mkdir(my_textgrid)
        except OSError:
            print('Creation of directory %s failed' %my_textgrid)

    my_textgrid_converted = './my_textgrid_converted'
    if not os.path.exists(my_textgrid_converted):
        try:
            os.mkdir(my_textgrid_converted)
        except OSError:
            print('Creation of directory %s failed' %my_textgrid_converted)

    my_textgrid_final = './my_textgrid_final'
    if not os.path.exists(my_textgrid_final):
        try:
            os.mkdir(my_textgrid_final)
        except OSError:
            print('Creation of directory %s failed' %my_textgrid_final)