<template>
    <h1>Mint USDC</h1>
    <button v-show="!store.state.connected" class="btn btn-lg btn-primary" data-bs-toggle="modal" data-bs-target="#connect">Connect Wallet</button>
    <div v-show="store.state.connected">
        <button @click="mint" :disabled="locked" class="btn btn-lg btn-primary">Mint USDC</button>
    </div>
</template>

<script>
    import { ref } from "vue";
    import { useStore } from "vuex";

    export default {
        setup() {
            const store = useStore();
            const locked = ref(false);

            async function mint() {
                locked.value = true;
                const paymentContract = new web3.eth.Contract(JSON.parse(store.state.usdcAbi), store.state.usdcAddress);
                store.commit("notice", "Waiting on response from wallet");
                try {
                    const gasPrice = Math.round(await web3.eth.getGasPrice());
                    let gas = Math.round(await paymentContract.methods.mint(store.state.account, "1000000000000").estimateGas({ from: store.state.account, gasPrice: gasPrice }) * 2);
                    const result = await paymentContract.methods.mint(store.state.account, "1000000000000").send({ from: store.state.account, gasPrice: gasPrice, gas: gas });
                    store.commit("notice", "Transaction successful! TXID: " + result.blockHash);
                } catch (error) {
                    store.commit("alert", error.message);
                }
                locked.value = false;
            }

            return {
                store,
                mint,
                locked,
            }
        }

    }
</script>
