// Get Props
let tagManagerContainerId = document.head.querySelector('meta[name="tag-manager-container-id"]');
let networkId = document.head.querySelector('meta[name="network-id"]');
let networkName = document.head.querySelector('meta[name="network-name"]');
let rpc = document.head.querySelector('meta[name="rpc"]');
let recaptcha = document.head.querySelector('meta[name="recaptcha"]');
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
// Vue
import { createApp } from "vue";
import { VueReCaptcha } from "vue-recaptcha-v3";
import App from "./App.vue";
import router from "./router";
createApp(App, {
    networkId: networkId.content,
    networkName: networkName.content,
    rpc: rpc.content,
    recaptcha: recaptcha.content,
}).use(router).use(VueReCaptcha).mount('#app');
