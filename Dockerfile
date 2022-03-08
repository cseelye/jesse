FROM ghcr.io/cseelye/pydev-base
ENV PYTHONUNBUFFERED 1

# Install TA-lib
RUN curl -sSLf http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz -o /tmp/ta-lib.tar.gz && \
    tar xzf /tmp/ta-lib.tar.gz && \
    cd ta-lib && \
    sed -i.bak "s|0.00000001|0.000000000000000001 |g" src/ta_func/ta_utility.h && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    make clean && \
    rm -f /tmp/ta-lib.tar.gz && \
    rm -f /tmp/ta-lib

# Install python modules
COPY requirements.txt /tmp/requirements.txt
RUN pip \
        --disable-pip-version-check \
        --no-cache-dir \
        install \
        --no-compile \
        --upgrade \
        --requirement /tmp/requirements.txt

# Create an editable install of jesse
RUN mkdir -p /workspace
COPY . /workspace
RUN pip install --editable /workspace
