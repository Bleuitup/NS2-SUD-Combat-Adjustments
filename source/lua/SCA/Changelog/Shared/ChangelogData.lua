-- The SCA in-game changelog text, in English, Portuguese and Spanish.
--
-- MAINTENANCE: a hand-kept copy of the change list in mod.settings. When the Workshop description
-- changes, change this too, in all three languages. The description uses terse "X -> Y" notes;
-- this window writes each change as a full sentence.
--
-- The three tables stay line-for-line parallel: same sections, same order, same number of entries.
--
-- Left in English in all three: lifeform names, trait and ability names (Carapace, Focus, Aura,
-- Leap, Vampirism, Xenocide, Swipe, Charge, Bone Shield, Stomp, Regeneration), hive types (Crag,
-- Shift, Shade), Tier, weapon names, Medpack, Medtech, Improved Resupply and ARC. That is what
-- players say in game.
--
-- Markup (see SplitHeadingLevel in GUISCAChangelogWindow.lua; only a LEADING '#' counts, so
-- "Medtech #2" is plain text):
--   # line    section heading (ALIENS, MARINES, ...)
--   ## line   subsection heading (Traits, Skulk, ...)
--   "  - "    a change
--   no prefix body prose
--
-- One quoted string per line, never a [[ ]] long string: NS2's script preprocessor breaks on a
-- "--" inside a multi-line long string.
--
-- Saved as UTF-8 for the accented letters.

local kChangelogs = {}

kChangelogs.en =
{
    "Combat, rebalanced to play closer to the semi-competitive game NS2 Sudamerica runs on its public server. That server runs Blast to the Past on top of nu vanilla, so several changes here come from there. This list is only what SCA changes on top of Combat.",
    "",
    "# ALIENS",
    "",
    "## Traits",
    "  - No more stacking one hive type: you can't take a second Crag, Shift or Shade trait until you have one of each, and no third until you have two of each. Stacking Carapace, Regeneration and Vampirism made aliens far too hard to kill. Locked traits show in red in the evolve menu, and hovering one tells you what to take first.",
    "  - Carapace now emphasizes biomass synergy. As in vanilla, it gives a base amount of armor plus more for every biomass level, and your biomass here is 1 at the start, 5 with Tier 2 and 9 with Tier 3 (+4 per Tier). Skulk +6 / +10 / +14 armor, Onos +70 / +150 / +230. Combat gave the biomass 12 amount from the first point (Skulk +17, Onos +290).",
    "  - Each Tier upgrade (Tier 2 and Tier 3 abilities) gives the health of 4 biomass levels: Skulk +12, Gorge +8, Lerk +8, Fade +20, Onos +200 per Tier. In Combat, Tier 3 was worth 5 levels.",
    "  - Focus cost reduced from 2 points to 1, and its bonus is vanilla's +33% (Combat had +34%).",
    "  - Aura only shows an enemy's health while that enemy is parasited (originally from CompMod, now in nuvanilla post b344).",
    "Why Focus changed: focus being 2 points is a vestige from the time focus boosted damage by +50%, resulting in 112.5 damage swipes / bites, meaning a clean 1hk on an unarmored marine. UWE nerfed it, and rightfully so, so that it would do slightly less than 100 damage per hit. The current focus mirrors vanilla one.",
    "",
    "## Skulk",
    "  - Leap energy cost increased from 45 to 55 (CompMod value).",
    "  - Vampirism reduced: each bite gives you 11.3% of your max health as shield, down from 14% (CompMod value).",
    "  - Xenocide removed.",
    "",
    "## Lerk",
    "  - Lerk health reduced from 180 to 170 (CompMod value).",
    "  - Lerk spike damage increased from 5 to 5.5.",
    "",
    "## Fade",
    "  - New Fade-only Advanced Swipe upgrade: 1 point, needs Tier 3. Swipe damage +8%, from 75 to 81.",
    "",
    "## Onos",
    "  - Charge comes with the Onos, as in vanilla. It used to need Tier 2, which now gives Bone Shield.",
    "  - Bone Shield hitpoints reduced from 1000 to 600.",
    "  - Stomp no longer knocks Marines down, it webs them for 5 seconds instead (CBM's Stomp). Damage increased from 40 to 50, energy cost from 30 to 45.",
    "",
    "# MARINES",
    "",
    "## Weapons",
    "  - The Machine Gun is a sidegrade to the Shotgun: 2 points with no Shotgun needed (was Shotgun + 1 point), and you keep it when you die. You pick one: owning either locks the other.",
    "  - Flamethrower and Grenade Launcher unlock from the Shotgun or the Machine Gun.",
    "  - Shotgun weapon upgrades increased from 7.84% to 10% per level, Flamethrower and Grenade Launcher from 7% to 10%, the same as every other weapon.",
    "  - Shotgun falloff starts at 7.5m (was 5m) and ends at 17.5m (was 15m).",
    "  - Grenade Launcher damage increased from 70 to 74.4 (vanilla value).",
    "Why the Machine Gun changed: when Combat was made, it did 12 damage per bullet to lifeforms and was priced as an upgrade over the Shotgun. Vanilla has since nerfed it to 10.5, so it is priced as the Shotgun's equal here.",
    "",
    "## Support",
    "  - Improved Resupply also gives you Medtech #2: your Medpacks heal 40 at once and 10 over time (was 25 and 25).",
    "  - Welding gives twice the XP, on teammates and on structures.",
    "  - ARC health increased from 1000 to 1500, armor from 200 to 500.",
    "  - Each ARC heads for the hive from a different side in turn, by a random route through the map's rooms, so Aliens can't just wait in one corridor. It still deploys on the hive as before.",
    "  - ARC spawns are no longer skipped. Combat sometimes lost an ARC when its spawn spot had no path to the hive, and the next one came a full interval late.",
    "",
    "# EXPERIENCE",
    "",
    "  - Assists: anyone who dealt more than 10% of an enemy's health and armor since it was last at full health now shares the kill XP, even if far away or already dead. Before, only the killer and teammates close to the kill shared it.",
    "  - Catch-up: every 5 minutes, anyone below 61% of the average XP is raised to it, as Combat intended. Combat's own check almost never fired.",
    "",
    "# SPAWN PROTECTION",
    "",
    "  - Stays at Combat's 3 seconds for the first 10 minutes of a 25 minute round.",
    "  - 10 to 15 minutes: 2.4 seconds (-20%).",
    "  - 15 to 20 minutes: 1.8 seconds (-40%).",
    "  - From 20 minutes on, overtime included: 1.2 seconds (-60%).",
    "  - A shorter or longer round moves the steps with it: they come at 40%, 60% and 80% of the round.",
    "  - Everyone gets a warning 30 seconds before each drop.",
    "The longer a round goes, the easier it gets to finish it.",
    "",
    "# CREDITS",
    "",
    "Author: Bleu",
    "",
    "Developed for the NS2 Sudamerica community. Join us at discord.gg/NS2-Sudamerica",
    "",
    "Several changes here are ported or adapted from Blast to the Past, ENSL CompMod and the Community Balance Mod.",
}

kChangelogs.pt =
{
    "O Combat, rebalanceado para jogar mais perto do jogo semicompetitivo que o NS2 Sudamerica roda no seu servidor público. Esse servidor roda o Blast to the Past por cima do nu vanilla, então várias mudanças aqui vêm de lá. Esta lista é só o que o SCA muda por cima do Combat.",
    "",
    "# ALIENS",
    "",
    "## Traits",
    "  - Chega de empilhar um só tipo de hive: você não pode pegar um segundo trait de Crag, Shift ou Shade até ter um de cada, nem um terceiro até ter dois de cada. Empilhar Carapace, Regeneration e Vampirism deixava os aliens difíceis demais de matar. Os traits bloqueados aparecem em vermelho no menu de evolução, e passar o mouse em cima de um diz o que pegar primeiro.",
    "  - Carapace agora valoriza a sinergia com a biomassa. Como no vanilla, dá uma quantidade base de armor mais um extra por cada nível de biomassa, e aqui sua biomassa é 1 no começo, 5 com Tier 2 e 9 com Tier 3 (+4 por Tier). Skulk +6 / +10 / +14 de armor, Onos +70 / +150 / +230. O Combat dava a quantidade de biomassa 12 desde o primeiro ponto (Skulk +17, Onos +290).",
    "  - Cada melhoria de Tier (habilidades de Tier 2 e Tier 3) dá a vida de 4 níveis de biomassa: Skulk +12, Gorge +8, Lerk +8, Fade +20, Onos +200 por Tier. No Combat, o Tier 3 valia 5 níveis.",
    "  - Custo do Focus reduzido de 2 pontos para 1, e o bônus é o do vanilla, +33% (o Combat tinha +34%).",
    "  - Aura só mostra a vida de um inimigo enquanto ele estiver parasitado (originalmente do CompMod, agora no nuvanilla desde o b344).",
    "Por que o Focus mudou: o Focus custar 2 pontos é um resquício da época em que ele aumentava o dano em +50%, o que dava swipes / mordidas de 112,5 de dano, ou seja, um 1hk limpo num marine sem armor. A UWE nerfou ele, e com razão, para que desse um pouco menos de 100 de dano por golpe. O Focus atual é igual ao do vanilla.",
    "",
    "## Skulk",
    "  - Custo de energia do Leap aumentado de 45 para 55 (valor do CompMod).",
    "  - Vampirism reduzido: cada mordida te dá 11,3% da sua vida máxima como escudo, antes 14% (valor do CompMod).",
    "  - Xenocide removido.",
    "",
    "## Lerk",
    "  - Vida do Lerk reduzida de 180 para 170 (valor do CompMod).",
    "  - Dano dos spikes do Lerk aumentado de 5 para 5,5.",
    "",
    "## Fade",
    "  - Nova melhoria Advanced Swipe, só para Fade: 1 ponto, precisa de Tier 3. Dano do Swipe +8%, de 75 para 81.",
    "",
    "## Onos",
    "  - Charge vem com o Onos, como no vanilla. Antes precisava de Tier 2, que agora dá Bone Shield.",
    "  - HP do Bone Shield reduzido de 1000 para 600.",
    "  - Stomp não derruba mais os marines, em vez disso prende eles em teia por 5 segundos (o Stomp do CBM). Dano aumentado de 40 para 50, custo de energia de 30 para 45.",
    "",
    "# MARINES",
    "",
    "## Armas",
    "  - A Machine Gun é uma alternativa à Shotgun: 2 pontos sem precisar da Shotgun (antes era Shotgun + 1 ponto), e você não perde ela quando morre. Você escolhe uma: ter qualquer uma bloqueia a outra.",
    "  - Flamethrower e Grenade Launcher se desbloqueiam com a Shotgun ou com a Machine Gun.",
    "  - Melhorias de arma da Shotgun aumentadas de 7,84% para 10% por nível, as do Flamethrower e do Grenade Launcher de 7% para 10%, igual a todas as outras armas.",
    "  - A queda de dano da Shotgun começa a 7,5m (antes 5m) e termina a 17,5m (antes 15m).",
    "  - Dano do Grenade Launcher aumentado de 70 para 74,4 (valor do vanilla).",
    "Por que a Machine Gun mudou: quando o Combat foi feito, ela dava 12 de dano por bala nas formas de vida e tinha preço de melhoria sobre a Shotgun. Desde então o vanilla reduziu para 10,5, então aqui ela custa o mesmo que a Shotgun.",
    "",
    "## Suporte",
    "  - Improved Resupply também te dá o Medtech #2: seus Medpacks curam 40 na hora e 10 ao longo do tempo (antes 25 e 25).",
    "  - Soldar dá o dobro de XP, em companheiros e em estruturas.",
    "  - Vida do ARC aumentada de 1000 para 1500, armor de 200 para 500.",
    "  - Cada ARC vai até a hive por um lado diferente a cada vez, por uma rota aleatória entre as salas do mapa, para que os aliens não possam só esperar num corredor. Ele continua se posicionando na hive como antes.",
    "  - Os ARCs não são mais pulados. O Combat às vezes perdia um ARC quando o ponto de spawn não tinha caminho até a hive, e o próximo chegava um intervalo inteiro atrasado.",
    "",
    "# EXPERIÊNCIA",
    "",
    "  - Assistências: quem causou mais de 10% da vida e do armor de um inimigo desde a última vez que ele estava com tudo cheio agora divide a XP do abate, mesmo estando longe ou já morto. Antes só dividiam o autor do abate e os companheiros perto dele.",
    "  - Recuperação: a cada 5 minutos, quem estiver abaixo de 61% da XP média sobe até ela, como o Combat pretendia. A verificação do próprio Combat quase nunca disparava.",
    "",
    "# PROTEÇÃO DE SPAWN",
    "",
    "  - Fica nos 3 segundos do Combat nos primeiros 10 minutos de uma rodada de 25 minutos.",
    "  - De 10 a 15 minutos: 2,4 segundos (-20%).",
    "  - De 15 a 20 minutos: 1,8 segundos (-40%).",
    "  - A partir dos 20 minutos, prorrogação incluída: 1,2 segundos (-60%).",
    "  - Uma rodada mais curta ou mais longa move as etapas junto: elas chegam aos 40%, 60% e 80% da rodada.",
    "  - Todo mundo recebe um aviso 30 segundos antes de cada redução.",
    "Quanto mais uma rodada dura, mais fácil fica terminá-la.",
    "",
    "# CRÉDITOS",
    "",
    "Autor: Bleu",
    "",
    "Desenvolvido para a comunidade NS2 Sudamerica. Entre com a gente em discord.gg/NS2-Sudamerica",
    "",
    "Várias mudanças aqui são portadas ou adaptadas do Blast to the Past, do ENSL CompMod e do Community Balance Mod.",
}

kChangelogs.es =
{
    "Combat, rebalanceado para jugar más cerca del juego semicompetitivo que NS2 Sudamerica corre en su servidor público. Ese servidor corre Blast to the Past por encima del nu vanilla, así que varios cambios de acá vienen de ahí. Esta lista es solo lo que SCA cambia por encima de Combat.",
    "",
    "# ALIENS",
    "",
    "## Traits",
    "  - Se acabó apilar un solo tipo de hive: no podés tomar un segundo trait de Crag, Shift o Shade hasta tener uno de cada, ni un tercero hasta tener dos de cada. Apilar Carapace, Regeneration y Vampirism hacía a los aliens demasiado difíciles de matar. Los traits bloqueados se ven en rojo en el menú de evolución, y al pasar el mouse por uno te dice qué tomar primero.",
    "  - Carapace ahora potencia la sinergia con la biomasa. Como en el vanilla, da una cantidad base de armor más un extra por cada nivel de biomasa, y acá tu biomasa es 1 al empezar, 5 con Tier 2 y 9 con Tier 3 (+4 por Tier). Skulk +6 / +10 / +14 de armor, Onos +70 / +150 / +230. Combat daba la cantidad de biomasa 12 desde el primer punto (Skulk +17, Onos +290).",
    "  - Cada mejora de Tier (habilidades de Tier 2 y Tier 3) da la vida de 4 niveles de biomasa: Skulk +12, Gorge +8, Lerk +8, Fade +20, Onos +200 por Tier. En Combat, el Tier 3 valía 5 niveles.",
    "  - Costo de Focus reducido de 2 puntos a 1, y su bonus es el del vanilla, +33% (Combat tenía +34%).",
    "  - Aura solo muestra la vida de un enemigo mientras está parasitado (originalmente de CompMod, ahora en el nuvanilla desde el b344).",
    "Por qué cambió Focus: que Focus cueste 2 puntos es un resto de la época en que aumentaba el daño un +50%, lo que daba swipes / mordidas de 112,5 de daño, o sea, un 1hk limpio a un marine sin armor. UWE lo nerfeó, y con razón, para que hiciera un poco menos de 100 de daño por golpe. El Focus actual es igual al del vanilla.",
    "",
    "## Skulk",
    "  - Costo de energía del Leap aumentado de 45 a 55 (valor de CompMod).",
    "  - Vampirism reducido: cada mordida te da 11,3% de tu vida máxima como escudo, antes 14% (valor de CompMod).",
    "  - Xenocide eliminado.",
    "",
    "## Lerk",
    "  - Vida del Lerk reducida de 180 a 170 (valor de CompMod).",
    "  - Daño de los spikes del Lerk aumentado de 5 a 5,5.",
    "",
    "## Fade",
    "  - Nueva mejora Advanced Swipe, solo para Fade: 1 punto, requiere Tier 3. Daño del Swipe +8%, de 75 a 81.",
    "",
    "## Onos",
    "  - Charge viene con el Onos, como en el vanilla. Antes requería Tier 2, que ahora da Bone Shield.",
    "  - HP de Bone Shield reducido de 1000 a 600.",
    "  - Stomp ya no tira a los marines al piso, en cambio los atrapa en telaraña por 5 segundos (el Stomp de CBM). Daño aumentado de 40 a 50, costo de energía de 30 a 45.",
    "",
    "# MARINES",
    "",
    "## Armas",
    "  - La Machine Gun es una alternativa a la Shotgun: 2 puntos sin necesitar la Shotgun (antes era Shotgun + 1 punto), y no la perdés al morir. Elegís una: tener cualquiera bloquea la otra.",
    "  - Flamethrower y Grenade Launcher se desbloquean con la Shotgun o con la Machine Gun.",
    "  - Mejoras de arma de la Shotgun aumentadas de 7,84% a 10% por nivel, las del Flamethrower y el Grenade Launcher de 7% a 10%, igual que todas las demás armas.",
    "  - La caída de daño de la Shotgun empieza a los 7,5m (antes 5m) y termina a los 17,5m (antes 15m).",
    "  - Daño del Grenade Launcher aumentado de 70 a 74,4 (valor del vanilla).",
    "Por qué cambió la Machine Gun: cuando se hizo Combat, hacía 12 de daño por bala a las formas de vida y tenía precio de mejora sobre la Shotgun. Desde entonces el vanilla la bajó a 10,5, así que acá cuesta lo mismo que la Shotgun.",
    "",
    "## Soporte",
    "  - Improved Resupply también te da el Medtech #2: tus Medpacks curan 40 al instante y 10 con el tiempo (antes 25 y 25).",
    "  - Soldar da el doble de XP, en compañeros y en estructuras.",
    "  - Vida del ARC aumentada de 1000 a 1500, armor de 200 a 500.",
    "  - Cada ARC va hacia la hive por un lado distinto cada vez, por una ruta al azar entre los cuartos del mapa, para que los aliens no puedan esperar en un solo pasillo. Se sigue desplegando en la hive como antes.",
    "  - Los ARCs ya no se saltean. Combat a veces perdía un ARC cuando su punto de spawn no tenía camino a la hive, y el siguiente llegaba un intervalo entero tarde.",
    "",
    "# EXPERIENCIA",
    "",
    "  - Asistencias: quien haya hecho más del 10% de la vida y el armor de un enemigo desde la última vez que estuvo lleno ahora comparte la XP de la kill, aunque esté lejos o ya muerto. Antes solo la compartían el que mató y los compañeros cerca de la kill.",
    "  - Nivelación: cada 5 minutos, quien esté por debajo del 61% de la XP promedio sube hasta ella, como Combat pretendía. El chequeo propio de Combat casi nunca se activaba.",
    "",
    "# PROTECCIÓN DE SPAWN",
    "",
    "  - Se queda en los 3 segundos de Combat durante los primeros 10 minutos de una ronda de 25 minutos.",
    "  - De 10 a 15 minutos: 2,4 segundos (-20%).",
    "  - De 15 a 20 minutos: 1,8 segundos (-40%).",
    "  - Desde los 20 minutos, overtime incluido: 1,2 segundos (-60%).",
    "  - Una ronda más corta o más larga mueve los escalones con ella: llegan al 40%, 60% y 80% de la ronda.",
    "  - Todos reciben un aviso 30 segundos antes de cada baja.",
    "Cuanto más dura una ronda, más fácil es terminarla.",
    "",
    "# CRÉDITOS",
    "",
    "Autor: Bleu",
    "",
    "Desarrollado para la comunidad NS2 Sudamerica. Sumate en discord.gg/NS2-Sudamerica",
    "",
    "Varios cambios acá son portados o adaptados de Blast to the Past, ENSL CompMod y el Community Balance Mod.",
}

kSCAChangelogLanguages = { "en", "pt", "es" }

-- NS2's own language setting from Options. Any locale without a translation here gets English.
local kLocaleToLanguage =
{
    ptBR = "pt",
    esES = "es",
}

function GetSCADefaultChangelogLanguage()

    if not Client then return "en" end

    local locale = Client.GetOptionString("locale", "enUS")
    return kLocaleToLanguage[locale] or "en"

end

function GetSCAChangelogText(language)
    return table.concat(kChangelogs[language] or kChangelogs.en, "\n")
end
