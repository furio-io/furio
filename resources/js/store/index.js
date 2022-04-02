import { createStore } from "vuex";

export default createStore({
    state: {
        networkId: null,
        networkName: null,
        rpc: null,
        recaptcha: null,
        notice: null,
        alert: null,
        wallet: null,
        connected: false,
        account: null,
        address: {
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
        },
        usdcAddress: null,
        usdcAbi: null,
        presaleNftAddress: null,
        presaleNftAbi: null,
    },
   mutations: {
       networkId(state, value) {
           state.networkId = value;
       },
       networkName(state, value) {
           state.networkName = value;
       },
       rpc(state, value) {
           state.rpc = value;
       },
       recaptcha(state, value) {
           state.recaptcha = value;
       },
       notice(state, value) {
           state.notice = value;
       },
       alert(state, value) {
           state.alert = value;
       },
       wallet(state, value) {
           state.wallet = value;
       },
       connected(state, value) {
           state.connected = value;
       },
       account(state, value) {
           state.account = value;
       },
       address(state, value) {
           state.address = value;
       },
       usdcAddress(state, value) {
           state.usdcAddress = value;
       },
       usdcAbi(state, value) {
           state.usdcAbi = value;
       },
       presaleNftAddress(state, value) {
           state.presaleNftAddress = value;
       },
       presaleNftAbi(state, value) {
           state.presaleNftAbi = value;
       },
   }
});
