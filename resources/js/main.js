// Get Props
let tagManagerContainerId = document.head.querySelector('meta[name="tag-manager-container-id"]');
// Bootstrap
import "bootstrap";
// Axios
window.axios = require('axios');
window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
// Tag Manager
import Analytics from "analytics";
import googleTagManager from "@analytics/google-tag-manager";
window.analytics = Analytics({
    app: location.hostname,
    plugins: [
        googleTagManager({
            containerId: tagManagerContainerId.content,
        }),
    ],
});
// Web3
import Web3 from "web3";
window.web3 = new Web3();
// Vue
import { createApp } from "vue";
import { VueReCaptcha } from "vue-recaptcha-v3";
import App from "./App.vue";
import router from "./router";
import store from "./store";
createApp({
    components: {
        App,
    }
}).use(router).use(store).use(VueReCaptcha).mount('#app');
