import { createStore } from "vuex";
import Web3 from "web3";

export default createStore({
   state: {
       web3: new Web3(),
       notice: null,
       alert: null,
       wallet: null,
       connected: false,
       account: null,
       address: null,
   },
   mutations: {
       notice(state, notice) {
           state.notice = notice;
       },
       alert(state, alert) {
           state.alert = alert;
       },
       wallet(state, wallet) {
           state.wallet = wallet;
       },
       provider(state, provider) {
           state.web3.setProvider(provider);
       },
       connect: async function (state) {
            try {
                state.alert = null;
                await state.web3.currentProvider.enable();
                const accounts = await state.web3.eth.getAccounts();
                state.account = accounts[0];
                state.connected = true;
                await axios.post('/api/v1/address', {
                    address: state.account,
                }).then(response => {
                    state.address = response.data.data;
                }).catch(error => {});
                //this.updateSession();
            } catch (error) {
                state.alert = error.message;
                return false;
            }
            state.notice = null;
            state.connected = true;
       }
   }
});
