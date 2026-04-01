
#!/bin/bash
export CDS_Netlisting_Mode=Analog

# tsmc65 installation path
export TSMC65_INST_DIR=/courses/ee4321/tech/tsmc65/T-N65-CM-SP-018-K3_MOM/Base_PDK/PDK_CRN65GP_v1.0c_official_IC61_20101010
 


export CDSHOME=/tools/cadence/IC618

# Calibre setup
#setenv UMC65LL_DRC_RULE_DIR $UMC65LL_INST_DIR/RuleDecks/Calibre/DRC
export TSMC65_LPE_RULE_DIR=/courses/ee4321/tech/tsmc65/T-N65-CM-SP-018-K3_MOM/Base_PDK/PDK_CRN65GP_v1.0c_official_IC61_20101010/Calibre/rcx/
#setenv TSMC65_LPE_RULE_DIR /usr/ltech/tsmc65/T-N65-CM-SP-018-K3_MOM/PDK_CRN65GP_v1.0c_official_IC61_20101010_all/PDK_CRN65GP_v1.0c_official_IC61_20101010/Calibre/rcx/

export WORKSPACEHOME=/courses/ee4321/shared/
export CALIBRE_RUNDIR=~/calibre_rundir/



export cds6=/tools/cadence/IC618
export PATH={$PATH}:$cds6
export PATH={$PATH}:$cds6/tools/bin
export PATH={$PATH}:$cds6/tools/dfII/bin


umask 007
# start virtuoso
virtuoso &
