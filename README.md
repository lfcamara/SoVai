# SoVai

Plugin Claude Code com um engineering workflow de uso geral — serve para qualquer projeto individual, não é atrelado a nenhum. Reúne skills e agentes organizados por bloco do processo de implementação.

## Blocos do workflow

- **Planejamento** — ✅ implementado
- **Prototipagem** — ✅ implementado
- **Desenvolvimento** — ✅ implementado
- **Testes e review** — ✅ implementado
- **Finalização de trabalho** — ✅ implementado
- **Debug** — ✅ implementado

## O pipeline

Contínuo: cada skill encadeia na próxima dentro da mesma sessão, sem invocação manual entre etapas.

```
ideia nova → brainstorm → to-prd → to-spec → to-wireframes → to-phases
                                                                 │
                          ┌──────────────────────────────────────┘
                          └─ por fase: prototype → frontend-design → to-tickets
```

Tudo antes de `to-phases` roda uma vez. Tudo depois roda uma vez **por fase**, quando aquela fase começa — planejar o detalhe de uma fase futura é planejar contra um codebase que já terá mudado.

| Skill | Bloco | Entrega |
|---|---|---|
| [`brainstorm`](skills/planning/brainstorm/SKILL.md) | Planejamento | Reconhece uma ideia não-moldada e a molda via `grilling` + `domain-modeling` até haver entendimento compartilhado |
| [`to-prd`](skills/planning/to-prd/SKILL.md) | Planejamento | `<effort> — PRD.md` — problema, solução, user stories, em linguagem de negócio |
| [`to-spec`](skills/planning/to-spec/SKILL.md) | Planejamento | `<effort> — Spec.md` — decisões de implementação, seams de teste, escopo técnico |
| [`to-wireframes`](skills/prototyping/to-wireframes/SKILL.md) | Prototipagem | `<effort> — Wireframes.md` + artifact HTML — todas as telas e os fluxos, em baixa fidelidade de propósito |
| [`to-phases`](skills/planning/to-phases/SKILL.md) | Planejamento | `<effort> — Roadmap.md` — fases que entregam valor isoladamente (teste do cancelamento) |
| [`prototype`](skills/prototyping/prototype/SKILL.md) | Prototipagem | Protótipo descartável — variações de UI para escolher, ou modelo de estado para dirigir na mão |
| `frontend-design` | — | Design visual final. Skill ambiente, não é deste plugin — apenas apontamos para ela |
| [`to-tickets`](skills/planning/to-tickets/SKILL.md) | Planejamento | Tickets tracer-bullet no tracker (Linear por padrão) |

Todas as skills são model-invoked: é o que permite uma alcançar a outra. Skill user-invoked não pode ser chamada por outra skill.

Tudo que um esforço produz vive em `docs/planning/<effort>/`. O `to-prd` nomeia o diretório; toda etapa seguinte o resolve a partir do filesystem — é o que permite retomar uma fase semanas depois, em sessão limpa.

### Configuração por projeto

O plugin não tem skill de setup, de propósito: só existe um fato que ele não consegue descobrir sozinho — o **team e o project do Linear** onde os tickets deste repo vivem.

Esse fato vai no `CLAUDE.md` do repo-alvo, que já é carregado em toda sessão. Não há passo de setup para lembrar de rodar, e o orquestrador — que é quem publica ticket — já o tem em contexto.

Para um projeto que fuja do padrão (outro tracker, outra forma de expressar bloqueio), escreva `docs/agents/issue-tracker.md` à mão; `to-tickets` e `open-pr` o leem quando existe e caem no default Linear quando não.

Decisões de design registradas em [`docs/adr/`](docs/adr/) — vale ler antes de mexer no pipeline.

## Desenvolvimento

Por ticket, executado por subagente. Estados no tracker: **To Do → Doing → Testing → Done** — todas as transições são do orquestrador, porque subagente que morre no meio deixaria o ticket travado, e implementer que marca o próprio `Done` corrige a própria prova.

| Skill | Entrega |
|---|---|
| [`tdd`](skills/development/tdd/SKILL.md) | Loop red → green. Importado sem alteração — o upstream já relocava refatoração para o review, igual ao que queríamos |
| [`implement`](skills/development/implement/SKILL.md) | Um ticket, do contexto limpo até branch pushado e verificado |
| [`ui-testing`](skills/development/ui-testing/SKILL.md) | Testes de UI derivados da tabela story→tela da nota de Wireframes |
| [`open-pr`](skills/development/open-pr/SKILL.md) | Draft PR após o primeiro push (o teste vermelho), ticket e PR linkados nos dois sentidos |

TDD é obrigatório no backend. UI é a exceção deliberada — testada depois, porque teste escrito contra uma tela cuja forma ainda se move quebra a cada mudança de layout sem pegar defeito real.

Lint, build e coverage rodam **dentro** do implementer: o output gigante morre com o subagente. A fronteira já é o escudo, não precisa de agente extra.

## Review

Cinco eixos independentes, despachados em paralelo como subagentes `reviewer` (read-only) e reportados separadamente — sem merge, sem reranking, para que um eixo limpo não enterre um que falhou.

| Skill | Pergunta que responde |
|---|---|
| [`review`](skills/review/review/SKILL.md) | Despachante: fixa o diff, seleciona os eixos aplicáveis, agrega |
| [`code-review`](skills/review/code-review/SKILL.md) | **Como** foi escrito — padrões do repo + 12 code smells do Fowler. É onde a refatoração vive |
| [`spec-review`](skills/review/spec-review/SKILL.md) | Se foi construída **a coisa certa** — o eixo que os outros quatro não pegam |
| [`test-review`](skills/review/test-review/SKILL.md) | Se os testes falhariam numa regressão real. Coverage % é sinal fraco, não alvo |
| [`security-review`](skills/review/security-review/SKILL.md) | Superfície de ataque. Achado precisa nomear caminho concreto até o dano |
| [`migration-review`](skills/review/migration-review/SKILL.md) | Migrations — reversibilidade, expand–contract, backfill. Aqui o modo de falha é perda de dados |

Achados são rankeados pelo eixo que os encontrou: **critical, high, medium, low**. Critical e high são **sempre** corrigidos — o `wrap-up` não mergeia com nenhum deles aberto, por mais firme que tenha sido a aprovação. Medium e low só se você mandar.

Cada achado registra **por que não foi prevenido** — o *cause*. Achado é defeito pego; cause que se repete é buraco no processo, e são coisas diferentes. O registro fica no vault do projeto.

## Vault e retroalimentação

O `docs/` do projeto **é** um vault Obsidian — vault é só uma pasta de markdown, então nada precisa ser criado e nada sai do repo. Documentos se linkam com wikilinks, e é isso que forma o grafo. Nomes carregam o effort (`checkout-flow — Spec.md`) porque o grafo só mostra o nome do nó: quinze efforts renderizariam quinze nós chamados "spec".

| Skill | Entrega |
|---|---|
| [`harden`](skills/knowledge/harden/SKILL.md) | Lê registros de review, agrupa por *cause*, e transforma recorrência em emenda na skill que deveria ter prevenido |

O `harden` roda **periodicamente, nunca por review** — uma ocorrência não é padrão. Roda no repo do SoVai (onde as skills vivem) lendo vaults dos projetos que você apontar: um cause que aparece uma vez em cada um de três projetos é invisível de dentro de qualquer um deles.

A emenda **compete com o que já existe**: regra quase certa é afiada, não acompanhada de uma segunda ao lado — regra adicionada por incidente é o *sediment* que o `writing-great-skills` alerta, e é justamente como a regra original ficou fraca o bastante para deixar passar.

E **propõe, não aplica**: mudança de skill altera toda execução futura.

## Debug

[`diagnose`](skills/debug/diagnose/SKILL.md) — adaptado do `diagnosing-bugs` do mattpocock, com dois deltas.

**Termina no ticket de bug, não no fix.** O fix entra pelo pipeline normal — `implement` com TDD, `review`, `wrap-up`. Um caminho só para todo código, e o diagnóstico vira durável em vez de morrer com a sessão que o produziu.

**Começa na evidência.** O original já começa no loop de feedback; aqui, primeiro se obtém a evidência — preferencialmente indo buscar (base, browser, logs) em vez de confiar no relato, porque relato é versão de segunda mão.

O núcleo é preservado: **o loop de feedback é a skill**. Um comando tight, red-capable e determinístico é o que acha o bug — e *"reaching for a hypothesis before this command exists is the exact failure this skill prevents."*

Hipóteses (3–5, ranqueadas, falsificáveis) são testadas por **subagentes em paralelo**, uma por agente: são independentes por construção, e um agente testando várias em sequência ancora na primeira.

O ticket carrega evidência, comando de repro, repro minimizado, causa raiz, **análise de seam** para o teste de regressão — e quando não existe seam correto, essa ausência é ela própria um achado.

## Finalização

[`wrap-up`](skills/wrap-up/wrap-up/SKILL.md) — roda na sessão do orquestrador, nunca em subagente.

Merge é o único ato irreversível e voltado pra fora do pipeline, então é autorizado **só pela sua aprovação explícita daquele PR**. Reviews passando e CI verde são sinais que você pesa ao aprovar — não são a aprovação. E aprovar um PR não autoriza o próximo.

Ordem importa: merge → confirmar que entrou → tracker → documentos. Ticket movido pra `Done` antes de um merge que falha é tracker mentindo, e nada depois consegue detectar.

A parte substantiva é reconciliar os documentos, sob uma regra: **documento segue decisão, não diff.** Código divergiu da spec porque alguém decidiu diferente durante o build → a spec está desatualizada, atualiza. Divergiu porque o código está errado → isso é defeito do `spec-review`, e reescrever a spec pra bater **transformaria o bug em requisito**. Distinguir os dois é o julgamento que a etapa existe pra fazer.

Fecha o loop por fase: quando o último ticket da fase entra, os critérios de saída do Roadmap são **verificados, não presumidos** — e a próxima fase ganha seu próprio `to-tickets`.

## Orquestração

A sessão principal (Opus) orquestra; a execução vai para subagentes (Sonnet).

| Agente | Tools | Papel |
|---|---|---|
| [`implementer`](agents/implementer.md) | escrita + bash | Executa tarefa especificada até o fim, verifica, reporta |
| [`reviewer`](agents/reviewer.md) | somente leitura | Confere contra critério explícito. Não edita — reviewer que conserta destrói a evidência |
| `Explore` | — | Busca. Já existe no ambiente, não recriamos |

A skill [`delegate`](skills/orchestration/delegate/SKILL.md) define o contrato do **brief**. Subagente nasce frio e não pode perguntar, então o brief carrega: resultado, skill, caminhos absolutos dos insumos, critério de pronto checável, cerca de escopo e o que reportar de volta.

Regra que evita o erro mais caro: decisão não resolvida **volta**, não é chutada localmente.

Não há agentes por cargo (frontend, backend, devops) — o porquê está na [ADR-0006](docs/adr/0006-agents-split-by-execution-mode-not-by-job-title.md).

Os blocos restantes serão construídos sobre a mesma base.

## Skills importadas

Importadas de [mattpocock/skills](https://github.com/mattpocock/skills) (MIT license — ver [`third_party/mattpocock-skills/LICENSE`](third_party/mattpocock-skills/LICENSE)):

| Skill | Local | O que faz |
|---|---|---|
| `writing-great-skills` | `skills/productivity/writing-great-skills` | Referência de como escrever skills previsíveis. Usada como guia toda vez que criarmos uma skill nova para os blocos acima. |
| `grilling` | `skills/productivity/grilling` | Motor base da entrevista "grill": interroga uma decisão/plano ramo a ramo até haver entendimento compartilhado. |
| `grill-me` | `skills/productivity/grill-me` | Wrapper leve de `grilling` — só a entrevista, sem gerar documentação. |
| `grill-with-docs` | `skills/engineering/grill-with-docs` | Wrapper de `grilling` que também aciona `domain-modeling`, registrando ADRs e glossário conforme a conversa avança. |
| `domain-modeling` | `skills/engineering/domain-modeling` | Disciplina de manter `CONTEXT.md` (glossário) e `docs/adr/` (decisões) atualizados durante o desenvolvimento. Dependência de `grill-with-docs`. |

Importadas sem alteração. Mantêm o `agents/openai.yaml` original (compatibilidade com outros harnesses de agente).

### Adaptadas da mesma fonte

| Skill | Adaptação |
|---|---|
| [`prototype`](skills/prototyping/prototype/SKILL.md) | O original assume alvo web (`?variant=` na URL, router do Next) e codebase existente. Generalizado: o switcher é especificado pelas propriedades que precisa ter, não pelo mecanismo, e ganhou um host standalone (artifact) para projetos que ainda não têm código. `LOGIC.md` veio praticamente intacto — já era agnóstico. |
| [`to-tickets`](skills/planning/to-tickets/SKILL.md) | Regras de vertical slice e expand–contract preservadas. Removida a dependência do skill de setup do repo original; escopo passou a ser por fase. |
| [`to-spec`](skills/planning/to-spec/SKILL.md) | Metade técnica do `to-spec` original (a metade de negócio virou `to-prd`). O raciocínio de **seams** foi preservado — é o núcleo da skill. |

## Uso

Não é preciso invocar nada por nome: descreva uma ideia nova e o `brainstorm` reconhece, molda, e o pipeline segue sozinho.

Para invocar uma etapa isolada — retomar uma fase, refazer um documento — chame a skill pelo nome.

`grill-me` para uma entrevista avulsa sem gerar documentação; `grill-with-docs` quando a decisão vale registro em ADR/glossário.

`writing-great-skills` é leitura obrigatória antes de escrever qualquer skill nova neste plugin.

## Próximos passos

Blocos de desenvolvimento, testes/review, debug e finalização, usando `writing-great-skills` como guia.
