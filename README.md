# ChatGPTGame

Este é um jogo que utiliza o modelo ChatGPT 3.5 para interpretar alguns personagens. É uma Prova de Conceito (POC). O Vídeo de teste pode ser visto [aqui](https://youtu.be/sbVHW4yIRbo)

## Como funciona
Primeiro algumas premissas iniciais são concatenadas com a estrutura do chat do personagem, e então enviadas via API:
```
premissa = "vamos fingir que estamos em uma consversa presencial, e vocé chatGPT é o personagem "+name_character+", responda de forma curta ao que "+sender_current+" falou em current_conversation e aguarde, sempre coloque "+name_character+": antes da resposta,leve em consideração conversation_history, leve consideração as quests"
```
```
chat = {
	"chat": {
		"storyteller": "A história se passa em um mundo medieval fictício, onde a magia e a espada se unem em aventuras épicas.",
		"environment": "A noite está escura e chuvosa. Galahad está no topo de uma colina, olhando para a cidade abaixo.",
		"name": "Galahad",
		"description": "Galahad é um jovem cavaleiro em busca de aventuras e honra. Ele é muito habilidoso com a espada e sempre está disposto a ajudar aqueles que precisam.",
		"comments": [
			"Galahad parece ser um personagem interessante e bem desenvolvido.",
			"Estou curioso para saber quais serão as aventuras que ele irá enfrentar.",
			"A descrição do ambiente está muito bem feita, consigo visualizar tudo em minha mente."
		],
		"conversation_history": {
			"Merlin": [
				"Merlin: Olá, jovem Galahad.",
				"Galahad: Olá, grande Merlin. O que o traz por aqui?",
				"Merlin: Vim lhe entregar uma missão muito importante. Você está disposto a aceitá-la?",
				"Galahad: Claro! Estou sempre pronto para uma boa aventura."
			],
			"Princesa Isadora": [
				"Princesa Isadora: Galahad, meu herói! O que você tem feito ultimamente?",
				"Galahad: Princesa, estou sempre em busca de novas aventuras e desafios para provar minha coragem.",
				"Princesa Isadora: Você é realmente um valente cavaleiro. Conte-me mais sobre suas últimas aventuras."
			]
		},
		"current_conversation": {},
		"quests": [
			{
				"name": "Encontre o portador da Espada Sagrada",
				"description": "Ajude Merlin a encontrar o portador da Espada Sagrada, aquele destinado a derrotar o mal que ameaça o reino.",
				"reward": "A gratidão de Merlin e a chance de fazer parte de uma jornada épica."
			},
			{
				"name": "Recrute os melhores guerreiros do reino",
				"description": "Apoie Merlin na tarefa de convocar os melhores guerreiros do reino para enfrentar as forças do mal.",
				"reward": "A honra de lutar ao lado dos melhores guerreiros e a oportunidade de salvar o reino."
			}
		]
	}
}
 ```

Este é body atualmente exigido pela API da OpenIA: 
```
 {     "model": "gpt-3.5-turbo",     "messages": [{"role": "user", "content":_message}],     "temperature": 0.7   }
```
Nesse caso de exemplo a `_message` seria substituido pelo resultado da concatenação da `premissa` com o a estrutura `chat`
<br>A cada iteração o `current_conversation` é atualizado com o dialogo resultante.
E por fim quando a conversa é encerrada, o histórico da conversa é salvo em `conversation_history`, que pode ser usado para retomar a conversa mais tarde, se necessário.
## Ferramentas

O jogo utiliza a versão Trial da API diposnibilizada pela OpenAI, versão Trial é limitada 3 requições por minuto, a documentação está disponível em https://platform.openai.com/docs/api-reference.<br>
O modelo utilizado é o "gpt-3.5-turbo".<br>
A engine utilizada é a Godot 4.0, que está diposnivel em: https://godotengine.org/.

## Como jogar

Para jogar, basta subistituir a `_api_key` da classe `APIChatGPT` que esta salva no diretorio `src/classes/` por uma api key valida. e então executar o projeto

## Screenshots

Aqui estão algumas capturas de tela do jogo:

<img src="https://github.com/FranciscoMesquita360/ChatGPTGame/blob/main/src/screenshort/Captura%20de%20tela%202023-04-30%20122419.png">
<img src="https://github.com/FranciscoMesquita360/ChatGPTGame/blob/main/src/screenshort/Captura%20de%20tela%202023-04-30%20122634.png">
<img src="https://github.com/FranciscoMesquita360/ChatGPTGame/blob/main/src/screenshort/Captura%20de%20tela%202023-04-30%20122807.png">

## Contribuição

Se você gostaria de contribuir para este projeto, fique à vontade para fazer um fork do repositório e enviar pull requests com as suas modificações.

## Licença

Este projeto está licenciado sob a Licença MIT - consulte o arquivo LICENSE para obter mais detalhes.
