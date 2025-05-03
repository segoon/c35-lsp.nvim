import yaml
import sys
import os
import json
import subprocess

ARC_ROOT = subprocess.check_output(['arc', 'root'], encoding='utf8').strip()


def read_cmy(fname):
    with open(fname, 'r') as ifile:
        return yaml.safe_load(ifile)


def read_plugin_paths(content):
    plugins = []
    for key in content:
        if '/' in key:
            plugins.append(key)
    return plugins


def read_plugin_schema(plugin_path):
    fname = os.path.join(ARC_ROOT, plugin_path, 'codegen-plugin.yaml')
    with open(fname, 'r') as ifile:
        try:
            return yaml.safe_load(ifile)['code']['uservices']['schema']
        except KeyError:
            return {}


def make_schema(content):
    schema = {
        'type': 'object',
        'additionalProperties': False,
        'properties': {
            'framework': {'const': 'uservices'},
            'type': {
                'type': 'string',
            },
        },
    }

    plugins = read_plugin_paths(content)
    for plugin in plugins:
        plugin_schema = read_plugin_schema(plugin)
        schema['properties'][plugin] = plugin_schema
    return schema


def main():
    content = read_cmy(sys.argv[1])
    schema = make_schema(content)
    print(json.dumps(schema))


if __name__ == '__main__':
    main()
