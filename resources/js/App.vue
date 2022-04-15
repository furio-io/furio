<template>
    <div class="header pb-5">
        <div class="container">
            <!-- BEGIN NAV -->
            <nav class="navbar pb-5 text-light">
                <a class="navbar-brand" href="https://furio.io">
                    <img src="/images/furio-logo.svg" alt="Furio Logo" width="175">
                </a>
                <Connect class="ms-auto"/>
            </nav>
        </div>
    </div>
    <!-- END NAV -->
    <!-- BEGIN NOTICES -->
    <div v-show="store.state.notice" class="alert alert-success alert-dismissible fade show" role="alert">
        <div class="container py-3">
            {{ store.state.notice }}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
    <div v-show="store.state.alert" class="alert alert-danger alert-dismissible fade show" role="alert">
        <div class="container py-3">
            {{ store.state.alert }}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
    <!-- END NOTICES -->
    <div class="container">
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
        <!-- BEGIN PAGE CONTENT -->
        <div class="container py-5 px-5 bg-light text-dark">
            <router-view class="mb-5 py-5"/>
        </div>
        <div class="mt-5 py-5">
            <h5 class="mb-3">Furio Rewards Responsibilty</h5>
            <p>Participation within the Furio Ecosystem is entirely at your own discretion. Please conduct your own research and read all of the available information. Remember that crypto currencies and the performance of projects carry no guarantees and you should not take on unnecessary risks. Material published by Furio should not be considered as financial advice.</p>
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
