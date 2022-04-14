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
        <div v-show="store.state.address.attributes.email && store.state.address.attributes.email_verified_at && max.value">
            <input v-model="max" type="number" class="form-control" id="max">
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
            const max = ref(0);
            const supply = ref(0);
            const value = ref(0);
            const price = ref(0);

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
                if(!max.value) {
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
                    max.value = await contract.value.methods.max().call();
                    supply.value = await contract.value.methods.supply().call();
                    value.value = await contract.value.methods.value().call();
                    price.value = await contract.value.methods.price().call();
                } catch (error) {
                    store.commit("alert", error.message);
                }
            }

            async function purchase() {
                store.commit("notice", "Waiting on response from wallet");
                try {
                    const gasPrice = Math.round(await web3.eth.getGasPrice());
                    let gas = Math.round(await paymentContract.value.methods.approve(store.state.presaleNftAddress, price.value * max.value).estimateGas({ from: store.state.account, gasPrice: gasPrice }) * 2);
                    await paymentContract.value.methods.approve(store.state.presaleNftAddress, price.value).send({ from: store.state.account, gasPrice: gasPrice, gas: gas });
                    //await paymentContract.value.methods.approve(store.state.presaleNftAddress, price.value).send({ from: store.state.account, gasPrice: gasPrice });
                    gas = Math.round(await contract.value.methods.buy(max.value).estimateGas({ from: store.state.account, gasPrice: gasPrice}) * 2);
                    const result = await contract.value.methods.buy(max.value).send({ from: store.state.account, gasPrice: gasPrice, gas: gas });
                    //const result = await contract.value.methods.buy().send({ from: store.state.account, gasPrice: gasPrice });
                    console.log(result);
                } catch (error) {
                    store.commit("alert", error.message);
                }
                store.commit("notice", null);
                getContractData();
            }

            return {
                store,
                email,
                verification,
                submitEmail,
                submitVerification,
                purchase,
                max,
                supply,
                value,
                price,
            }
        }

    }
</script>
