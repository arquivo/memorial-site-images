# memorial-site-images

Centralized image asset repository for the [memorial](https://github.com/arquivo/memorial) application. It stores logos for archived Portuguese websites served by Arquivo.pt's memorial service.

This repository is a **dependency** of the `memorial` app — it is not a standalone project.

## Repository Structure

```
memorial-site-images/
├── img/        # All site logos
└── README.md   # This file
```

## How It's Used by Memorial

The `memorial` app consumes images from this repository in three ways:

**Docker (production):** mounted as a read-only volume:
```yaml
volumes:
  - ../memorial-site-images:/memorial-site-images:ro
```

**Configuration:** the `IMAGES_FOLDER` setting defaults to `../memorial-site-images/img`.

**Image serving:** the `/memorial-site-image` endpoint normalizes the requested hostname to a filename and looks it up in `IMAGES_FOLDER`. If no match is found, it falls back to the default `arquivo_pt_2024-preto.png` logo from the memorial app's `static/img/`.

Sites can also specify an explicit logo filename in `memorial/config.py`:
```python
"natolisboa2010.gov.pt": {
    "logo": "natolisboa2010_gov_pt.jpg",
    ...
}
```

## Naming Convention

Image filenames follow the domain name with dots (`.`) replaced by underscores (`_`):

```
domain.tld      →  domain_tld.png
sub.domain.tld  →  sub_domain_tld.png
```

**Example:** `elearning.rcaap.pt` → `elearning_rcaap_pt.png`

**Hyphens are preserved** as they appear in the original domain:
- `ad-lisboa.jpg` (ad-lisboa domain)
- `disaster-recovery.gif` (disaster-recovery.gov.pt)
- `inst-informatica.png` (inst-informatica.pt)
- `ccas.min-financas.jpg` (ccas.min-financas.pt)

**Supported extensions:** `.png`, `.jpg` / `.jpeg`, `.gif`, `.svg`

### Renamed Files

The following files were renamed during the May 2026 standardization:

| Original Filename | New Filename | Domain |
|---|---|---|
| apin.gov.pt.png | apin_gov_pt.png | apin.gov.pt |
| covid19estamoson.gov.pt.jpg | covid19estamoson_gov_pt.jpg | covid19estamoson.gov.pt |
| oe2022.gov.pt.png | oe2022_gov_pt.png | oe2022.gov.pt |
| oe2023.gov.pt.png | oe2023_gov_pt.png | oe2023.gov.pt |
| oe2024.gov.pt.png | oe2024_gov_pt.png | oe2024.gov.pt |
| portugalforukraine.gov.pt.png | portugalforukraine_gov_pt.png | portugalforukraine.gov.pt |
| votoantecipado.gov.pt.jpg | votoantecipado_gov_pt.jpg | votoantecipado.gov.pt |

## Adding a New Image

1. Convert the site's domain to a filename: replace `.` with `_`, preserve `-`
2. Place the file in `img/`
3. Reference the filename in `memorial/config.py` under the site's `logo` field:
   ```python
   "example.gov.pt": {
       "logo": "example_gov_pt.png",
       ...
   }
   ```
4. Run `bash validate.sh` to confirm the filename is valid before pushing
5. Verify locally by running the memorial app and checking the `/memorial-site-image?host=example.gov.pt` endpoint

## Local Development Setup

Both repositories must be cloned as siblings so the default relative path resolves correctly:

```
arquivo/
├── memorial/
└── memorial-site-images/
```

```bash
git clone https://github.com/arquivo/memorial.git
git clone https://github.com/arquivo/memorial-site-images.git
```

## Related Resources

- [memorial](https://github.com/arquivo/memorial) — the main application
- [arquivo/pwa-technologies#1488](https://github.com/arquivo/pwa-technologies/issues/1488) — naming convention standardization issue
