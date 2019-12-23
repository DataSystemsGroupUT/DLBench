<template>
  <div id="app">
    <AppHeader v-if="isAuthendicatedUser()"></AppHeader>
    <router-view/>
  </div>
</template>

<style lang="scss">
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;

  a {
    font-weight: bold;
    color: #2c3e50;

    &.router-link-exact-active {
      color: #42b983;
    }
  }
}

.textButton{
  font-weight: bold !important;
}
</style>
<script>
    import AppHeader from "./components/AppHeader";
    export default {
        components: {AppHeader},
        methods: {
            isAuthendicatedUser() {
                return this.$store.getters.token != null
            }
        }
    }
</script>
