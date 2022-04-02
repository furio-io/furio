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
    import { ref } from "vue";
    import { useStore } from "vuex";

    export default {
        setup() {
            const store = useStore();
            const email = ref(null);
            const verification = ref(null);
            const maxPerUser = ref(0);
            const maxSupply = ref(0);
            const price = ref(0);
            const totalCreated = ref(0);
            const tokenValue = ref(0);
            const nftValue = ref(0);
            const paymentToken = ref(null);
            const usdContract = ref(null);
            const presaleNftContract = ref(null);

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
                if(store.state.connected) {
                    presaleNftContract = new web3.eth.Contract(JSON.parse(store.state.presaleNftAbi), store.state.presaleNftAddress);
                    paymentToken = await presaleNftContract.value.methods.paymentToken().call();
                    usdcContract = new web3.eth.Contract(JSON.parse(store.state.usdcAbi), paymentToken.value);
                    maxPerUser = await presaleNftContract.value.methods.maxPerUser().call();
                }
            }

            async function purchase() {
                getContractData();
                alert(maxPerUser.value);
            }

            return {
                store,
                email,
                verification,
                submitEmail,
                submitVerification,
                purchase,
                maxPerUser,
            }
        }

    }
</script>
