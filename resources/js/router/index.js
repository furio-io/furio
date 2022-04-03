import { createRouter, createWebHistory } from "vue-router";

const routes = [
    {
        path: "/",
        name: "Home",
        component: () => import("../views/Home.vue"),
    },
    {
        path: "/presale",
        name: "Presale",
        component: () => import("../views/Presale.vue"),
    },
    {
        path: "/furswap",
        name: "Furswap",
        component: () => import("../views/Furswap.vue"),
    },
    {
        path: "/vault",
        name: "Vault",
        component: () => import("../views/Vault.vue"),
    },
    {
        path: "/:catchAll(.*)",
        component: () => import("../views/NotFound.vue"),
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
