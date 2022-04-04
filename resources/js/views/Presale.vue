<template>
    <h1>Presale</h1>
    <button v-show="!store.state.connected" class="btn btn-lg btn-primary" data-bs-toggle="modal" data-bs-target="#connect">Connect Wallet</button>
    <div v-show="store.state.connected">
        <div v-show="!store.state.address.attributes.email">
            <div class="mb-3">
                <label for="email" class="form-label">Enter your email address</label>
                <input v-model="email" type="email" class="form-control" id="email">
            </div>
            <button @click="submitEmail" class="btn btn-lg btn-primary">Submit</button>
        </div>
        <div v-show="store.state.address.attributes.email && !store.state.address.attributes.email_verified_at">
            <div class="mb-3">
                <label for="verification" class="form-label">Enter your email verification code</label>
                <input v-model="verification" type="text" class="form-control" id="verification">
            </div>
            <button @click="submitVerification" class="btn btn-lg btn-primary">Submit</button>
        </div>
        <div v-show="store.state.address.attributes.email && store.state.address.attributes.email_verified_at">
            <button @click="purchase" class="btn btn-lg btn-primary">Purchase</button>
        </div>
    </div>
</template>

<script>
    import { computed, onMounted, ref, watch } from "vue";
    import { useStore } from "vuex";

    export default {
        setup() {
            const store = useStore();
            const email = ref(null);
            const verification = ref(null);
            const contract = ref(null);
            const paymentContract = ref(null);
            const balance = ref(null);
            const maxPerUser = ref(null);
            const maxSupply = ref(null);
            const nftValue = ref(null);
            const paused = ref(null);
            const price = ref(null);
            const tokenValue = ref(null);
            const totalCreated = ref(null);

            const connected = computed(() => {
                return store.state.connected;
            });

            onMounted(async function () {
                //alert('hello');
            });

            watch(connected, async function (currentValue, oldValue) {
                if(oldValue) {
                    return;
                }
                if(!currentValue) {
                    return;
                }
                if(!maxPerUser.value) {
                    getContractData();
                }
            });

            async function submitEmail() {
                await axios.post('/api/v1/address', {
                    address: store.state.account,
                    email: email.value,
                }).then(response => {
                    store.commit("address", response.data.data);
                }).catch(error => {
                    store.commit("notice", null);
                    store.commit("alert", error.message);
                });
            }

            async function submitVerification() {
                await axios.post('/api/v1/address', {
                    address: store.state.account,
                    email_verification_code: verification.value,
                }).then(response => {
                    store.commit("address", response.data.data);
                }).catch(error => {
                    store.commit("notice", null);
                    store.commit("alert", error.message);
                });
            }

            async function getContractData() {
                try {
                    contract.value = new web3.eth.Contract(JSON.parse(store.state.presaleNftAbi), store.state.presaleNftAddress);
                    paymentContract.value = new web3.eth.Contract(JSON.parse(store.state.usdcAbi), store.state.usdcAddress);
                    balance.value = await contract.value.methods.balanceOf(store.state.account).call();
                    maxPerUser.value = await contract.value.methods.maxPerUser().call();
                    maxSupply.value = await contract.value.methods.maxSupply().call();
                    nftValue.value = await contract.value.methods.nftValue().call();
                    paused.value = await contract.value.methods.paused().call();
                    price.value = await contract.value.methods.price().call();
                    tokenValue.value = await contract.value.methods.tokenValue().call();
                    totalCreated.value = await contract.value.methods.totalCreated().call();
                } catch (error) {
                    store.commit("alert", error.message);
                }
            }

            async function purchase() {
                try {
                    const gasPrice = await web3.eth.getGasPrice();
                    const gasLimit = Math.round(await web3.eth.getGasLimit() * 2);
                    alert(gasLimit);
                    let gas = Math.round(await paymentContract.value.methods.approve(store.state.presaleNftAddress, price.value).estimateGas({ from: store.state.account, gasPrice: gasPrice }) * 2);
                    await paymentContract.value.methods.approve(store.state.presaleNftAddress, price.value).send({ from: store.state.account, gasPrice: gasPrice, gasLimit: gasLimit, gas: gas });
                    gas = Math.round(await contract.value.methods.buy().estimateGas({ from: store.state.account, gasPrice: gasPrice}) * 2);
                    const result = await contract.value.methods.buy().send({ from: store.state.account, gasPrice: gasPrice, gasLimit: gasLimit, gas: gas });
                    console.log(result);
                } catch (error) {
                    store.commit("alert", error.message);
                }
            }

            return {
                store,
                email,
                verification,
                submitEmail,
                submitVerification,
                purchase,
                balance,
                maxPerUser,
                maxSupply,
                nftValue,
                paused,
                price,
                tokenValue,
                totalCreated,
            }
        }

    }
</script>
