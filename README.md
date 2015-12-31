# Phan

This a docker image for [Phan](https://github.com/etsy/phan)

## Usage

```bash
docker run -v /path/to/php/files/:/scripts/ -w /scripts texthtml/phan -p -3 /scripts/vendor/ $(find /scripts/src/ /scripts/bin/ /scripts/vendor/ -type f -path '*.php')
```
