<template>
    <!-- BEGIN NAVIGATION -->
    <nav class="navbar navbar-expand-sm navbar-dark bg-dark">
        <div class="container-fluid">
            <router-link :to="{ name: 'Home' }" class="navbar-brand">Furio</router-link>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbar">
                <!-- BEGIN PRIMARY NAVIGATION -->
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <router-link :to="{ name: 'Presale' }" class="nav-link" active-class="active">Presale</router-link>
                    </li>
                </ul>
                <!-- END PRIMARY NAVIGATION -->
                <div class="d-flex">
                    <!-- BEGIN SECONDARY NAVIGATION -->
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link" href="https://furio.io/whitepaper" target="_new">Whitepaper</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="https://youtu.be/TOJg308iREw" target="_new">Tutorial</a>
                        </li>
                    </ul>
                    <!-- END SECONDARY NAVIGATION -->
                    <!-- BEGIN WALLET BUTTONS -->
                    <Connect/>
                    <!-- END WALLET BUTTONS -->
                </div>
            </div>
        </div>
    </nav>
    <!-- END NAVIGATION -->

    <!-- BEGIN NOTICES -->
    <div v-show="store.state.notice" class="alert alert-success alert-dismissible fade show" role="alert">
        {{ store.state.notice }}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <div v-show="store.state.alert" class="alert alert-danger alert-dismissible fade show" role="alert">
        {{ store.state.alert }}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <!-- END NOTICES -->

    <!-- BEGIN PAGE CONTENT -->
    <div class="container mt-5 mb-5">
        <router-view/>
    </div>
    <!-- END PAGE CONTENT -->

    <!-- BEGIN FOOTER CONTENT -->

    <!-- END FOOTER CONTENT -->
</template>

<script>
    import { onMounted } from "vue";
    import { useStore } from "vuex";
    import Connect from './components/Connect.vue';

    export default {
        components: { Connect },
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
