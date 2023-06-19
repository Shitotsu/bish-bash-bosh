import os
import yaml

def copy_deployments(namespace, output_dir):
    # Ngambil output deployment
    command = f"kubectl get deployments -n {namespace} -o json"
    output = os.popen(command).read()
    deployments = yaml.safe_load(output)["items"]

    # Buat Directory
    os.makedirs(output_dir, exist_ok=True)

    # Array Store Nama Deployment
    deployment_filenames = []

    # Nyimpen Output Yaml
    for deployment in deployments:
        deployment_name = deployment["metadata"]["name"]
        filename = f"{output_dir}/{deployment_name}.yaml"
        with open(filename, "w") as file:
            yaml.dump(deployment, file)
        print(f"Deployment '{deployment_name}' berhasil disalin ke '{filename}'")

        deployment_filenames.append(filename)

    # Nyimpen daftar nama file deployment dalam satu file
    list_filename = f"{output_dir}/deployment_list.txt"
    with open(list_filename, "w") as list_file:
        list_file.write("\n".join(deployment_filenames))

    print(f"Daftar nama file deployment disimpan di '{list_filename}'")

# Funtion
namespace = "default"
output_directory = "deployment_yaml"
copy_deployments(namespace, output_directory)
