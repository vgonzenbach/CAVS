# unzip files
#!/bin/bash
cd $(dirname $0)/..

for zip in $(find data_processed_zipped -name '*.zip'); do
    out_dir=$(echo $zip | sed 's/data_processed_zipped/data_processed_all/g' | xargs dirname)
    unzip -o -d $out_dir $zip
done