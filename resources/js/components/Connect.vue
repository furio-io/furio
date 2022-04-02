<template>
    <!-- CONNECT BUTTON -->
    <button v-show="!store.state.connected" class="btn btn-sm btn-primary mx-1" data-bs-toggle="modal" data-bs-target="#connect">Connect Wallet</button>
    <!-- END CONNECT BUTTON -->
    <!-- DISCONNECT BUTTON -->
    <button v-show="store.state.connected" @click="disconnect" class="btn btn-sm btn-danger mx-1">Disconnect {{ shortAccount }}</button>
    <!-- END DISCONNECT BUTTON -->
    <!-- CONNECT WALLET MODAL -->
    <div class="modal fade" id="connect" tabindex="-1" aria-labelledby="connectLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Connect Wallet</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md text-center">
                            <button @click="metamask" data-bs-dismiss="modal" class="btn btn-link">
                                <img class="img-fluid" src="/images/metamask.svg" alt="metamask">
                            </button>
                        </div>
                        <div class="col-md text-center">
                            <button @click="walletconnect" data-bs-dismiss="modal" class="btn btn-link">
                                <img class="img-fluid" src="/images/walletconnect.svg" alt="walletconnect">
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- END CONNECT WALLET MODAL -->
</template>

<script>
    import { computed } from "vue";
    import { useStore } from "vuex";

    export default {
        setup() {
            const store = useStore();
            const shortAccount = computed(() => {
                try {
                    return store.state.account.substr(0, 10) + "..." + store.state.account.substr(-4);
                } catch (error) {
                    return '';
                }
            });

            async function metamask() {
                store.commit("wallet", "metamask");
                try {
                    web3.setProvider(window.ethereum);
                    connect();
                } catch (error) {
                    store.commit("alert", error.message);
                    return disconnect();
                }
            }

            async function walletconnect() {
                store.commit("wallet", "walletconnect");
                try {
                    connect();
                } catch (error) {
                    store.commit("alert", error.message);
                    return disconnect();
                }
            }

            async function connect() {
                store.commit("notice", "Waiting on response form wallet");
                store.commit("alert", null);
                await web3.currentProvider.enable();
                if(parseInt(await web3.eth.net.getId()) != parseInt(store.state.networkId)) {
                    store.commit("notice", null);
                    store.commit("alert", "Incorrect network. Please connect to " + store.state.networkName);
                    return disconnect();
                }
                const accounts = await web3.eth.getAccounts();
                store.commit("account", accounts[0]);
                await axios.post('/api/v1/address', {
                    address: store.state.account,
                }).then(response => {
                    store.commit("address", response.data.data);
                }).catch(error => {
                    store.commit("notice", null);
                    store.commit("alert", error.message);
                    return disconnect();
                });
                const signature = await web3.eth.personal.sign(store.state.address.attributes.nonce, store.state.address.attributes.address, "");
                await axios.post('/api/v1/login', {
                    address: store.state.address.attributes.address,
                    nonce: store.state.address.attributes.nonce,
                    signature: signature,
                }).then(response => {
                    store.commit("connected", true);
                    store.commit("address", response.data.data);
                }).catch(error => {
                    store.commit("notice", null);
                    store.commit("alert", error.message);
                    return disconnect();
                });
                store.commit("notice", null);
                await axios.post('/api/v1/session', {
                    wallet: store.state.wallet,
                    account: store.state.account,
                    address: store.state.address,
                    connected: store.state.connected,
                }).then(response => {
                }).catch(error => {
                });
            }

            async function disconnect() {
                try {
                    web3.currentProvider.close();
                    web3.currentProvider.disconnect();
                } catch (error) {}
                store.commit("account", null);
                store.commit("address", {
                    type: 'addresses',
                    id: null,
                    attributes: {
                        address: null,
                        nonce: null,
                        logged_in: null,
                        name: null,
                        email: null,
                        email_verified_at: null,
                        created_at: null,
                        updated_at: null,
                    }
                });
                store.commit("connected", false);
                await axios.post('/api/v1/logout');
            }

            return {
                store,
                shortAccount,
                metamask,
                walletconnect,
                disconnect,
            }
        }
    }
</script>
