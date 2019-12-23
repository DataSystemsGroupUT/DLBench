<template>
  <div class="container login-container">
      <div class="login-form-1">
          <h3>Sign up</h3>
          <form>
              <div class="form-group">
                  <input
                    type="text"
                    class="form-control input"
                    placeholder="Email *"
                    v-model="email"
                  />
              </div>
              <div class="form-group">
                  <input
                    type="password"
                    class="form-control input"
                    :class="{ redBorder: password !== passwordRepeat }"
                    placeholder="Password *"
                    v-model="password"
                  />
              </div>
              <div class="form-group">
                  <input
                    type="password"
                    class="form-control input"
                    :class="{ redBorder: password !== passwordRepeat }"
                    placeholder="Repeat Password *"
                    v-model="passwordRepeat"
                  />
              </div>
              <div class="form-group">
                  <input
                    :disabled="password !== passwordRepeat && password !== ''"
                    :class="{ disabled: password !== passwordRepeat && password !== '' }"
                    type="submit"
                    @click="register"
                    class="btnSubmit"
                    value="Sign up"
                  />
              </div>
              <div class="form-group textButton">
                  <router-link to="/">
                    Already have an account? Login
                  </router-link>
              </div>
          </form>
      </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'register',
  data() {
    return {
      email: '',
      password: '',
      passwordRepeat: '',
    };
  },
  methods: {
    async register() {
      try {
        const userData = {
          user: {
            email: this.email,
            password: this.password,
          },
        };
        const { data: { token, email } } = await axios.post('http://localhost:4000/api/users/signup', userData);
        this.$store.commit('setToken', token);
          this.$store.commit('setEmail', email);
        this.$router.push('home');
        console.log('<----------------SIGNUP SUCCESS----------------->');
      } catch (e) {
        console.log('<----------------SIGNUP FAILED----------------->');
        console.log(e);
      }
    },
  },
};
</script>

<style scoped>
.login-container{
    max-width: 500px !important;
    margin-top: 5%;
    margin-bottom: 5%;
}
.login-form-1{
    padding: 5%;
    box-shadow: 0 5px 8px 0 rgba(0, 0, 0, 0.2), 0 9px 26px 0 rgba(0, 0, 0, 0.19);
}
.login-form-1 h3{
    text-align: center;
    color: #333;
}
.login-container form{
    padding: 10%;
}
.btnSubmit
{
    width: 50%;
    border-radius: 1rem;
    padding: 1.5%;
    border: none;
    cursor: pointer;
}
.login-form-1 .btnSubmit{
    font-weight: 600;
    color: #fff;
    background-color: #0062cc;
}
.login-form-1 .register{
    color: #0062cc;
    font-weight: 600;
    text-decoration: none;
}
.redBorder {
  border-color: red;
  border-width: 1.5px;
}
.input {
  border-radius: 20px;
}
.disabled {
  opacity: 70%;
}

</style>
