<template>
    <ul>
        <li v-for="message in messages">{{ message }}</li>
    </ul>
</template>

<script>
    import { ref, onMounted } from "vue";
    import Pusher from "pusher-js";
    import Echo from "laravel-echo";

    export default {
        setup() {
            const messages = ref([]);

            onMounted(async function () {
                var echo = new Echo({
                    broadcaster: 'pusher',
                    key: 'b24baf40ae13c0dc0a02',
                    cluster: 'us2',
                    forceTLS: true
                });
                var channel = echo.channel('dapp-events');
                channel.listen('.dapp-event', function(data) {
                    messages.push(JSON.stringify(data));
                });
            }) ;

            return {
                messages,
            }
        }
    }
</script>
