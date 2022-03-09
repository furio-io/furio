<template>
    <div class="wallet-connect">
        <button @click="connect" class="btn btn-link"><slot></slot></button>
    </div>
</template>

<script>
    import WalletConnectProvider from '@walletconnect/web3-provider';
    export default {
        props: [
            'chainId',
            'rpc',
        ],
        methods: {
            connect() {
                try {
                    this.$parent.web3.setProvider(new WalletConnectProvider({
                        rpc: {
                            [this.chainId]: this.rpc,
                        }
                    }));
                } catch (error) {
                    this.$parent.alert = error.message;
                    return false;
                }
                this.$parent.connect();
            }
        }
    }
</script>
