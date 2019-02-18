#
# PASO 1 - Carga y ejecución del fichero de interconexión con Twitter
#
#          IMPORTANTE: El fichero "Interconexión con Twitter.R" tiene
#                      que estar en el directorio de trabajo de R.
#
source("Interconexión con Twitter (ALUMNOS).R")

#
# PASO 2 - Empezar a leer datos de Twitter.
#

#
# Lee 200 tweets (en caso de existir) de la cuenta de la Casa Blanca
# (@WhiteHouse)
#
rdmTweets <- userTimeline("WhiteHouse", n=200)
print(rdmTweets)
class(rdmTweets)
str(rdmTweets[[1]])
str(rdmTweets[[2]])

#
# Buscar tweets que incluyan alguna palabra o término.
#
# Por ejemplo, sobre la palabra inglesa para "corazón" ("heart"):
#
s1 <- searchTwitter("heart", n=200, lang="EN")
s1

#
# O sobre la palabra española "corazón":
#
s2 <- searchTwitter("corazón", n=200, lang="ES", resultType="recent")
s2

# Ahora sin la tilde:
s2 <- searchTwitter("corazon", n=200, lang="ES", resultType="recent")
s2

# Ahora sin el indicador de idioma:
s2 <- searchTwitter("corazon", n=200, resultType="recent")
s2

# Ahora sin el indicador de idioma y con tilde:
s2 <- searchTwitter("corazón", n=200, resultType="recent")
s2

#
# O sobre la expresión francesa "je crois que" ("creo que"):
#
s3 <- searchTwitter("je crois que", n=200, lang="FR")
s3

#
# O sobre la expresión francesa "gilets jaunes" ("chalecos amarillos"):
#
s3 <- searchTwitter("gilets jaunes", n=200, lang="FR")
s3

#
# O sobre las palabras españolas "derecho" y "salud" (en cualquier orden):
#
s4 <- searchTwitter("gobierno + civil", n=200, lang="ES")
s4

#
# O sobre la palabra alemana "Bayern" o "Hand":
#
s5 <- searchTwitter("Bayern", n=200, lang="DE")
s5

s5 <- searchTwitter("Hand", n=200, lang="DE")
s5

# Con resultados sorprendentes :-(.
#[[1]]
#[1] "nielsfcr1999: Moest gwn geel voor Ronaldo zijn want zo lang de scheids niet fluit en jij hem expres met je hand raak is het een kaart toch @MReegen"







