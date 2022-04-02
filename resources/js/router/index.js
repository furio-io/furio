import { createRouter, createWebHistory } from "vue-router";
import Home from "../views/Home.vue";
import Presale from "../views/Presale.vue";
import Furswap from "../views/Furswap.vue";
import Vault from "../views/Vault.vue";
import Liquidity from "../views/Liquidity.vue";
import NotFound from "../views/NotFound.vue";

const routes = [
    {
        path: "/",
        name: "Home",
        component: Home,
    },
    {
        path: "/presale",
        name: "Presale",
        component: Presale,
    },
    {
        path: "/furswap",
        name: "Furswap",
        component: Furswap,
    },
    {
        path: "/vault",
        name: "Vault",
        component: Vault,
    },
    {
        path: "/liquidity",
        name: "Liquidity",
        component: Liquidity,
    },
    {
        path: "/:catchAll(.*)",
        component: NotFound,
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
