<template>
  <div>
    <div class="search-bar">
      <label class="input-label" for="nome_fantasia">Nome Fantasia:</label>
      <input class="input" v-model="nome_fantasia" @input="fetchRecords" placeholder="Buscar por nome fantasia..." />

      <label class="input-label" for="razao_social">Razao Social:</label>
      <input class="input" v-model="razao_social" @input="fetchRecords" placeholder="Buscar por razao social..." />

      <label class="input-label" for="registro_ans">ANS:</label>
      <input class="input" v-model="registro_ans" @input="fetchRecords" placeholder="Buscar por ANS..." />

      <label class="input-label" for="cnpj">CNPJ:</label>
      <input class="input" v-model="cnpj" @input="fetchRecords" placeholder="Buscar por CNPJ..." />
    </div>
    
    <div class="records">
      <div v-for="record in records" :key="record.cnpj" class="record-card">
        <h2>{{ record.razao_social}}</h2>
        <p v-if="record.nome_fantasia"><strong>Nome fantasia:</strong> {{ record.nome_fantasia}}</p>
        <p><strong>Registro ANS:</strong> {{ record.registro_ans }}</p>
        <p><strong>CNPJ:</strong> {{ record.cnpj }}</p>
        <p v-if="record.modalidade"><strong>Modalidade:</strong> {{ record.modalidade }}</p>
        <p><strong>Endereço:</strong> {{ record.logradouro }}, {{ record.numero }} - {{ record.bairro }}, {{ record.cidade }} - {{ record.uf }}</p>
        <p v-if="record.cep"><strong>CEP:</strong> {{ record.cep }}</p>
        <p v-if="record.telefone"><strong>Telefone:</strong> ({{ record.ddd}}) {{ record.telefone }}</p>
        <p v-if="record.fax"><strong>Fax:</strong> ({{ record.fax}}) {{ record.fax}}</p>
        <p v-if="record.endereco_eletronico"><strong>E-mail:</strong> {{ record.endereco_eletronico }}</p>
        <p v-if="record.representante"><strong>Representante:</strong> {{ record.representante }} - {{ record.cargo_representante }}</p>
        <p v-if="record.regiao_de_comercializacao"><strong>Região de Comercialização:</strong> {{ record.regiao_de_comercializacao }}</p>
        <p v-if="record.data_registro_ans"><strong>Data Registro ANS:</strong> {{ record.data_registro_ans }}</p>
      </div>
    </div>
    <div class="pagination">
      <button 
        @click="setPage(currentPage - 1)" 
        :disabled="currentPage <= 1"
      >
        Anterior
      </button>
      <span>{{ currentPage }} de {{ totalPages }}</span>
      <button 
        @click="setPage(currentPage + 1)" 
        :disabled="currentPage >= totalPages"
      >
        Próximo
      </button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      records: [],
      nome_fantasia: '',
      razao_social: '',
      registro_ans: '',
      cnpj: '',
      currentPage: 1,
      totalPages: 1,
      totalRecords: 0,
      perPage: 9 
    }
  },
  methods: {
    async fetchRecords() {
      try {
        const params = {
          page: this.currentPage,
          limit: this.perPage
        }

        if (this.nome_fantasia) params.nome_fantasia = this.nome_fantasia
        if (this.razao_social) params.razao_social= this.razao_social
        if (this.registro_ans) params.registro_ans = this.registro_ans
        if (this.cnpj) params.cnpj = this.cnpj
      console.log(import.meta.env.API_URL)

        const response = await axios.get(`${import.meta.env.VITE_API_URL}/records`, { params })
        this.records = JSON.parse(response.data.data)
        this.totalRecords = response.data.total_records
        this.totalPages = response.data.total_pages
      } catch (error) {
        console.error("Erro ao buscar registros:", error)
      }
    },
      setPage(page) {
      if (page < 1 || page > this.totalPages) return
      this.currentPage = page
      this.fetchRecords()
  },

  },
  mounted() {
    this.fetchRecords()
  }
}
</script>

<style scoped>
.search-bar {
  display: flex;
  gap: 1rem;
  margin-bottom: 20px;
  align-items: center;
}

.input {
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  width: 200px;
}

.input-label{
  font-size: 22px;
  font-weight: 400;
}

.records {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(500px, 1fr));
  gap: 1rem;
  max-width: 100%;
}

.record-card {
  background-color: white;
  border-radius: 8px;
  padding: 1rem;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.record-card h2 {
  margin: 0 0 0.5rem;
  font-size: 1.2rem;
  color: #007bff;
}

.record-card p{
  margin: 0 ;
}

.pagination {
  display: flex;
  align-items:center;
  justify-content: center;
  gap: 1rem;
  margin-top: 1rem;
}

.pagination button {
  padding: 0.5rem 1rem;
  border: 1px solid #007bff;
  background-color: white;
  color: #007bff;
  border-radius: 4px;
  cursor: pointer;
}

.pagination button:disabled {
  background-color: #f1f1f1;
  color: #ddd;
}
</style>
