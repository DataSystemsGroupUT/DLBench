<template>
  <!-- https://mdbootstrap.com/docs/jquery/navigation/navbar/ -->
  <nav class="navbar navbar-expand-sm bg-dark navbar-dark">
    <!-- Brand -->
    <a class="navbar-brand" href="#">Tartu Parking</a>

    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="collapsibleNavbar">
    <!-- Links -->
    <ul class="navbar-nav">
      <li class="nav-item">
        <router-link class="nav-link" to="/map">Map</router-link>
      </li>
    </ul>
    <ul class="navbar-nav ml-auto">
      <!-- Dropdown -->
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" id="navbarDropdownMenuLink-333" data-toggle="dropdown"
           aria-haspopup="true" aria-expanded="false">
          <img src="../assets/user.png" height="32" width="32"/>
        </a>
        <div class="dropdown-menu">
          <router-link class="dropdown-item" to="/profile">Profile</router-link>
        </div>
      </li>
    </ul>
    </div>
  </nav>
</template>

<script>
    export default {
        name: "AppHeader"
    }
</script>

<style scoped>

</style>
