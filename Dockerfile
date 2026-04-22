# syntax=docker/dockerfile:1

FROM python:3.11-slim-bookworm AS builder

ARG AUTOGERN_REPO=https://github.com/JChander/AutoGERN.git
ARG AUTOGERN_REF=AutoGERN1.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
    && rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}"
ENV PYTHONPATH="/opt/autogern:/opt/autogern/src"

WORKDIR /opt/autogern

RUN git clone --depth 1 --branch "${AUTOGERN_REF}" "${AUTOGERN_REPO}" . \
    && ln -s src/models.py models_intra.py \
    && ln -s src/searchspace.py searchspace_diffpool.py \
    && ln -s src/utils_LP.py utils_LP.py \
    && ln -s src/mlp.py mlp.py \
    && ln -s src/aggregate.py aggregate.py \
    && ln -s src/debug.py debug.py \
    && ln -s models.py src/models_intra.py \
    && ln -s searchspace.py src/searchspace_diffpool.py \
    && rm -rf .git

RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cpu torch==2.5.1 \
    && pip install --no-cache-dir \
        pyg_lib \
        torch_scatter \
        torch_sparse \
        torch_cluster \
        torch_spline_conv \
        -f https://data.pyg.org/whl/torch-2.5.1+cpu.html \
    && pip install --no-cache-dir \
        torch-geometric==2.6.1 \
        matplotlib \
        'networkx>=3.1' \
        'numpy>=1.24' \
        'pandas>=2.0' \
        'scikit-learn>=1.3' \
        tqdm \
    && python main_LP.py --help > /tmp/autogern-help.txt

FROM python:3.11-slim-bookworm

ENV PATH="/opt/venv/bin:${PATH}"
ENV PYTHONPATH="/opt/autogern:/opt/autogern/src"

COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /opt/autogern /opt/autogern

RUN printf '#!/usr/bin/env sh\nexec python /opt/autogern/main_LP.py "$@"\n' > /usr/local/bin/autogern \
    && chmod +x /usr/local/bin/autogern

WORKDIR /data
ENTRYPOINT ["autogern"]
CMD ["--help"]
