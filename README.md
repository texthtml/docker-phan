# Phan

This a docker image for [Phan](https://github.com/etsy/phan)

## Usage

```bash
docker run -v /path/to/php/files/:/scripts/ texthtml/phan -p -3 /scripts/vendor/ --directory /scripts/
```
