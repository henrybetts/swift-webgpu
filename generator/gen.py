from genlib.model import Model
import json
from glob import glob
import os
from jinja2 import Template


if __name__ == '__main__':
    with open('dawn.json') as f:
        model = Model(json.load(f), enabled_tags=['dawn', 'native', 'deprecated'])

    template_dir = 'templates'
    output_dir = '../Sources/WebGPU'

    templates_paths = glob(os.path.join(template_dir, '*.template'))

    for template_path in templates_paths:
        output_path = os.path.relpath(template_path, template_dir)[:-len('.template')]
        output_path = os.path.join(output_dir, output_path)

        with open(template_path) as f:
            template = Template(f.read(), lstrip_blocks=True, trim_blocks=True)

        with open(output_path, 'w') as f:
            f.write(template.render(model=model))

        print(f'Rendered {template_path} -> {output_path}')
