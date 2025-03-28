<template>
  <div id="app" class="container">
    <h1>Consulta de Registros</h1>
    <RecordList />
  </div>
</template>

<script>
import RecordList from './components/RecordList.vue'

export default {
  components: {
    RecordList
  }
}
</script>

<style>
#app {
  margin:0;
}

.container {
  margin: auto;
  padding: 10px 50px;
}
</style>
