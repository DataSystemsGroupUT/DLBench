<template>
  <div class="container emp-profile">
    <form method="post">
      <!-- https://bootsnipp.com/snippets/K0ZmK -->

      <div class="row">
        <div class="col-md-4">
          <div class="profile-work">
            <p>Links</p>
            <a >Invoices</a><br/>
            <a >Subscription</a><br/>
          </div>
        </div>
        <div class="col-md-8">
          <div class="tab-content profile-tab" id="myTabContent">
            <div class="tab-pane fade show active" id="home" role="tabpanel" aria-labelledby="home-tab">
              <div class="row">
                <div class="col-md-6">
                  <label>Email</label>
                </div>
                <div class="col-md-6">
                  <p>{{this.$store.getters.email}}</p>
                </div>
              </div>
              <div class="row">
                <div class="col-md-6">
                  <label>Name</label>
                </div>
                <div class="col-md-6">
                  <p>UserName</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>
</template>

<script>
    export default {
        name: "Profile"
    }
</script>

<style scoped>

</style>
