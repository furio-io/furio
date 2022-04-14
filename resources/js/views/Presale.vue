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
            <div v-show="max > 0">
                <input v-show="max > 1" v-model="quantity" :disabled="locked" :max="max" min="1" type="number" class="form-control mb-2" id="quantity">
                <input v-model="quantity" type="hidden">
                <button @click="purchase" :disabled="locked" class="btn btn-lg btn-primary">Purchase ({{ totalPrice / 1000000 }} USDC)</button>
            </div>
            <div v-show="max == 0">
                No presales are currently available.
            </div>
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
            const quantity = ref(0);
            const supply = ref(0);
            const value = ref(0);
            const price = ref(0);
            const locked = ref(false);
            const balance = ref(0);
            const ownedValue = ref(0);

            const connected = computed(() => {
                return store.state.connected;
            });

            const totalPrice = computed(() => {
                return price.value * quantity.value;
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
                locked.value = true;
                await axios.post('/api/v1/address', {
                    address: store.state.account,
                    email: email.value,
                }).then(response => {
                    store.commit("address", response.data.data);
                }).catch(error => {
                    store.commit("notice", null);
                    store.commit("alert", error.message);
                });
                locked.value = false;
            }

            async function submitVerification() {
                locked.value = true;
                await axios.post('/api/v1/address', {
                    address: store.state.account,
                    email_verification_code: verification.value,
                }).then(response => {
                    store.commit("address", response.data.data);
                }).catch(error => {
                    store.commit("notice", null);
                    store.commit("alert", error.message);
                });
                locked.value = false;
            }

            async function getContractData() {
                locked.value = true;
                try {
                    contract.value = new web3.eth.Contract(JSON.parse(store.state.presaleNftAbi), store.state.presaleNftAddress);
                    paymentContract.value = new web3.eth.Contract(JSON.parse(store.state.usdcAbi), store.state.usdcAddress);
                    max.value = await contract.value.methods.max(store.state.account).call();
                    quantity.value = max.value;
                    supply.value = await contract.value.methods.supply().call();
                    value.value = await contract.value.methods.value().call();
                    price.value = await contract.value.methods.price().call();
                    balance.value = await contract.value.methods.balanceOf(store.state.account).call();
                    ownedValue.value = await contract.value.methods.ownedValue(store.state.account).call();
                } catch (error) {
                    store.commit("alert", error.message);
                }
                locked.value = false;
            }

            async function purchase() {
                locked.value = true;
                store.commit("notice", "Waiting on response from wallet");
                try {
                    const gasPrice = Math.round(await web3.eth.getGasPrice());
                    let gas = Math.round(await paymentContract.value.methods.approve(store.state.presaleNftAddress, quantity.value * price.value).estimateGas({ from: store.state.account, gasPrice: gasPrice }) * 2);
                    await paymentContract.value.methods.approve(store.state.presaleNftAddress, quantity.value * price.value).send({ from: store.state.account, gasPrice: gasPrice, gas: gas });
                    gas = Math.round(await contract.value.methods.buy(quantity.value).estimateGas({ from: store.state.account, gasPrice: gasPrice}) * 2);
                    const result = await contract.value.methods.buy(quantity.value).send({ from: store.state.account, gasPrice: gasPrice, gas: gas });
                    store.commit("notice", "Transaction successful! TXID: " + result.blockHash);
                    console.log(result);
                } catch (error) {
                    store.commit("alert", error.message);
                }
                locked.value = false;
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
                quantity,
                supply,
                value,
                price,
                totalPrice,
                locked,
                balance,
                ownedValue,
            }
        }

    }
</script>
