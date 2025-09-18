FROM islandora/leptonica:main@sha256:a028717811d99ad90d3e2b222d4dd5e41c3a014006453b2137f41253798e0d56 AS leptonica
FROM ghcr.io/lehigh-university-libraries/scyllaridae:main@sha256:e962c522e49dd48afc11792b89505895ab29a37044ea95591881e299f856c27e

ARG \
  # renovate: datasource=repology depName=alpine_3_20/tesseract-ocr
  TESSERACT_VERSION="5.3.4-r0" \
  # renovate: datasource=repology depName=alpine_3_20/poppler-utils
  POPPLER_VERSION="24.02.0-r2"

RUN --mount=type=bind,from=leptonica,source=/packages,target=/packages \
    --mount=type=bind,from=leptonica,source=/etc/apk/keys,target=/etc/apk/keys \
    apk update && \
    apk add --no-cache \
        /packages/leptonica-*.apk \
        tesseract-ocr=="${TESSERACT_VERSION}" \
        tesseract-ocr-data-eng=="${TESSERACT_VERSION}" \
        tesseract-ocr-data-fra=="${TESSERACT_VERSION}" \
        tesseract-ocr-data-spa=="${TESSERACT_VERSION}" \
        tesseract-ocr-data-ita=="${TESSERACT_VERSION}" \
        tesseract-ocr-data-por=="${TESSERACT_VERSION}" \
        tesseract-ocr-data-hin=="${TESSERACT_VERSION}" \
        tesseract-ocr-data-deu=="${TESSERACT_VERSION}" \
        tesseract-ocr-data-jpn=="${TESSERACT_VERSION}" \
        tesseract-ocr-data-rus=="${TESSERACT_VERSION}" \
        tesseract-ocr-data-chi_tra=="${TESSERACT_VERSION}" \
        poppler-utils=="${POPPLER_VERSION}"

COPY scyllaridae.yml /app/scyllaridae.yml
