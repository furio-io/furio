<template>
    <div class="container">
        <!-- BEGIN NAV -->
        <ul class="nav nav-tabs">
            <li class="nav-item">
                <router-link :to="{ name: 'Presale' }" class="nav-link" active-class="active">Presale</router-link>
            </li>
            <li class="nav-item">
                <router-link :to="{ name: 'Swap' }" class="nav-link" active-class="active">Swap</router-link>
            </li>
            <li class="nav-item">
                <router-link :to="{ name: 'Vault' }" class="nav-link" active-class="active">Vault</router-link>
            </li>
            <li class="nav-item">
                <router-link :to="{ name: 'MintUsdc' }" class="nav-link" active-class="active">Mint USDC</router-link>
            </li>
        </ul>
        <!-- END NAV -->
        <!-- BEGIN NOTICES -->
        <div v-show="store.state.notice" class="alert alert-success alert-dismissible fade show" role="alert">
            {{ store.state.notice }}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <div v-show="store.state.alert" class="alert alert-danger alert-dismissible fade show" role="alert">
            {{ store.state.alert }}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <div class="text-end mt-1 mb-1">
            <Connect/>
        </div>
        <!-- END NOTICES -->
        <!-- BEGIN PAGE CONTENT -->
        <div class="container mt-5">
            <router-view/>
        </div>
        <!-- END PAGE CONTENT -->
    </div>
</template>

<script>
    import { onMounted } from "vue";
    import { useStore } from "vuex";
    import Connect from './components/Connect.vue';

    export default {
        components: {
            Connect,
        },
        props: {
            networkId: String,
            networkName: String,
            rpc: String,
            recaptcha: String,
            usdcAddress: String,
            usdcAbi: String,
            presaleNftAddress: String,
            presaleNftAbi: String,
        },
        setup(props) {
            const store = useStore();

            onMounted(async function () {
                store.commit("networkId", props.networkId);
                store.commit("networkName", props.networkName);
                store.commit("rpc", props.rpc);
                store.commit("recaptcha", props.recaptcha);
                store.commit("usdcAddress", props.usdcAddress);
                store.commit("usdcAbi", props.usdcAbi);
                store.commit("presaleNftAddress", props.presaleNftAddress);
                store.commit("presaleNftAbi", props.presaleNftAbi);
                await axios.get('/api/v1/session').then(response => {
                    store.commit("wallet", response.data.wallet);
                    store.commit("account", response.data.account);
                    store.commit("address", response.data.address);
                    //store.commit("connected", response.data.connected);
                }).catch(error => {
                    store.commit("alert", error.message);
                });
            });

            return {
                store,
            }
        }
    }
</script>
