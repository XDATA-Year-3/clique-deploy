FROM ubuntu:14.04
MAINTAINER Roni Choudhury <roni.choudhury@kitware.com>

# The environment variables beginning with KWDEMO can be used to map this demo
# to the main url space.  See the end of this file.
ENV KWDEMO_READY FALSE

EXPOSE 3000

RUN apt-get update && apt-get install -y \
    python \
    python-pip \
    git \
    npm

RUN pip install \
    pymongo \
    tangelo

# Need to symlink node to nodejs because Ubuntu names things in a way that npm
# doesn't expect.
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install gulp globally.
RUN npm install -g gulp

# Create and switch to a tangelo user
RUN useradd -c "tangelo user" -m -d /home/tangelo -s /bin/bash tangelo
USER tangelo
ENV HOME /home/tangelo
WORKDIR /home/tangelo

# Use https universally instead of git (comes up during bower phase).
RUN git config --global url."https://".insteadOf git://

# Clone the repo.
RUN git clone https://github.com/Kitware/clique && \
    cd clique && \
    git checkout fce1ad6c0abd974639b96fba5a54c8c6624f77d1 && \
    git reset --hard
WORKDIR clique

# Build clique.
RUN npm install
RUN gulp

COPY hostip.sh /home/tangelo/hostip.sh
RUN cp build/site/anb.html build/site/index.html

# Set up KWDemo vars.
ENV KWDEMO_NAME Clique Analyst Notebook
ENV KWDEMO_KEY clique-anb
ENV KWDEMO_SRCURL https://github.com/XDATA-Year-3/clique
ENV KWDEMO_DESC XDATA Clique application for exploring Analyst Notebook files
ENV KWDEMO_IMG /clique/assets/clique.svg
ENV KWDEMO_READY TRUE
ENV CLIQUE_HOST 0.0.0.0
ENV CLIQUE_PORT 3000

# Start the clique application when this image is run.
CMD ["sh", "-c", "sh /home/tangelo/hostip.sh >build/site/anb.json && gulp serve"]
