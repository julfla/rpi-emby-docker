FROM resin/rpi-raspbian:latest

RUN apt-get update && apt-get install -y imagemagick \
	imagemagick-6.q16 \
	imagemagick-common \
	libimage-magick-perl \
	libimage-magick-q16-perl \
	libmagickcore-6-arch-config \
	libmagickcore-6-headers \
	libmagickcore-6.q16-2 \
	libmagickcore-6.q16-2-extra \
	libmagickcore-6.q16-dev \
	libmagickwand-6-headers \
	libmagickwand-6.q16-2 \
	libmagickwand-6.q16-dev \
	libmagickwand-dev \
	webp \
	mediainfo \
	sqlite3

# Get last ffmpeg version
RUN sudo apt-get install -y git make && \
	cd /usr/src && git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg

RUN cd /usr/src/ffmpeg && ./configure && make && make && sudo make install

# Get mono
COPY mono-xamarin.list /etc/apt/sources.list.d/
RUN apt-key adv --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF &&
sudo apt-get update && sudo apt-get install -y mono-complete

# Install emby and configure it to run with our configuration

WORKDIR /opt/mediabrowser
ADD https://github.com/MediaBrowser/Emby.Releases/raw/master/Server/MediaBrowser.Mono.zip .
COPY ImageMagickSharp.dll.config .
COPY System.Data.SQLite.dll.config .
COPY MediaBrowser.MediaInfo.dll.config .

CMD ["/bin/bash"]
