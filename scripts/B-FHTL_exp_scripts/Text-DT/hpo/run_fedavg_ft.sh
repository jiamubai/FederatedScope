set -e

cd ../../../../

cudaid=$1
dataset=text-dt
outdir=exp_out/fedavg_ft
ckpt_dir=exp_out/fedavg

if [ ! -d ${outdir} ];then
  mkdir -p ${outdir}
fi

echo "HPO starts..."

seeds=(123 1234 12345)

log=${outdir}/${dataset}.log
for (( k=0; k<${#seeds[@]}; k++ ))
do
    python federatedscope/main.py \
    --cfg scripts/B-FHTL_exp_scripts/Text-DT/config_ft.yaml \
    --cfg_client scripts/B-FHTL_exp_scripts/Text-DT/config_client_fedavg_ft.yaml \
    device ${cudaid} \
    outdir $outdir/seed_$k \
    data.type ${dataset} \
    federate.method fedavg-textdt \
    federate.load_from $ckpt_dir/seed_$k/ckpt \
    seed ${seeds[$k]} >>${log} 2>&1
done
python federatedscope/parse_exp_results.py --input ${log}

echo "HPO ends."

cd scripts/B-FHTL_exp_scripts/Text-DT/hpo/