#!/usr/bin/env python3

from genlib.model import Model
import json
from jinja2 import Template
import argparse
from pathlib import Path


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--dawn-json', required=True, type=Path, help='Path to dawn.json')
    parser.add_argument('--templates', type=Path, default=Path(__file__).parent / 'templates',
                        help='Path to templates directory')
    parser.add_argument('--output', type=Path, default=Path(__file__).parent / '../Sources/WebGpu/Generated',
                        help='Path to output directory')
    parser.add_argument('--enabled-tags', type=str, nargs='*', default=['dawn', 'native', 'deprecated'],
                        help='Enables various tagged items to be included in the output')

    args = parser.parse_args()
    dawn_json_path: Path = args.dawn_json
    templates_dir: Path = args.templates
    output_dir: Path = args.output

    with dawn_json_path.open() as f:
        model = Model(json.load(f), enabled_tags=args.enabled_tags)

    output_dir.mkdir(exist_ok=True)

    templates_paths = templates_dir.glob('*.template')

    for template_path in templates_paths:
        template = Template(template_path.read_text(), lstrip_blocks=True, trim_blocks=True)

        output_path = output_dir / template_path.stem
        output_path.write_text(template.render(model=model))

        print(f'Rendered {template_path} -> {output_path}')
