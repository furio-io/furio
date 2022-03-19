<template>
    <div class="meta-mask">
        <button @click="connect2" class="btn btn-link"><slot></slot></button>
    </div>
</template>

<script>
    import { useStore } from "vuex";

    export default {
        setup() {
            const store = useStore();

            function connect2() {
                store.commit("wallet", "meta-mask");
                try {
                    store.commit("provider", window.ethereum);
                } catch (error) {
                    store.commit("alert", error.message);
                }
                store.commit("connect");
            }

            return {
                connect2,
            }
        },
        methods: {
            connect() {
                this.$parent.wallet = 'meta-mask';
                try {
                    if (typeof window.ethereum == 'undefined') {
                        window.location.href = 'https://metamask.app.link/dapp/' + location.hostname;
                        return false;
                    }
                    this.$parent.web3.setProvider(window.ethereum);
                } catch (error) {
                    this.$parent.alert = error.message;
                    return false;
                }
                this.$parent.connect();
            }
        }
    }
</script>
