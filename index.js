import sequelize from './shared/database/database.js'
import { usersRouter } from './users/router.js'
import express from 'express'

const app = express()
const PORT = process.env.PORT || 8000

app.use(express.json())

app.get('/health', async (_req, res) => {
  try {
    await sequelize.authenticate()
    res.status(200).json({ status: 'ok', service: 'demo-devops-nodejs' })
  } catch (error) {
    res.status(503).json({ status: 'error', message: 'database unavailable' })
  }
})

app.use('/api/users', usersRouter)

let server

if (process.env.NODE_ENV !== 'test') {
  server = app.listen(PORT, async () => {
    await sequelize.sync({ force: false })
    console.log(`Server running on port ${PORT}`)
  })
}

export { app, server }