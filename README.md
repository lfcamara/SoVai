# SoVai

Plugin Claude Code com o engineering workflow usado para desenvolver o app SoVai (mobile). Reúne skills e agentes organizados por bloco do processo de implementação.

## Blocos do workflow

- **Planejamento** — ✅ implementado (ver abaixo)
- **Desenvolvimento** — implementação guiada (TDD, domain modeling)
- **Testes e review** — code review, estratégia de testes
- **Debug** — diagnóstico e correção de bugs
- **Finalização de trabalho** — handoff, checklist de conclusão
- **Prototipagem** — exploração rápida de UI/fluxos

## Bloco de planejamento

Um pipeline contínuo: cada skill encadeia na próxima dentro da mesma sessão, sem invocação manual entre etapas.

```
ideia nova → brainstorm → to-prd → to-spec → to-phases → to-tickets
                                          └──────────────┘
                                    (to-tickets roda 1x por fase)
```

| Skill | Entrega |
|---|---|
| [`brainstorm`](skills/planning/brainstorm/SKILL.md) | Reconhece uma ideia não-moldada e a molda via `grilling` + `domain-modeling` até haver entendimento compartilhado |
| [`to-prd`](skills/planning/to-prd/SKILL.md) | `docs/planning/<slug>/prd.md` — problema, solução, user stories, em linguagem de negócio |
| [`to-spec`](skills/planning/to-spec/SKILL.md) | `docs/planning/<slug>/spec.md` — decisões de implementação, seams de teste, escopo técnico |
| [`to-phases`](skills/planning/to-phases/SKILL.md) | `docs/planning/<slug>/roadmap.md` — fases que entregam valor isoladamente (teste do cancelamento) |
| [`to-tickets`](skills/planning/to-tickets/SKILL.md) | Tickets tracer-bullet no tracker (Linear por padrão), por fase |

Decisões de design registradas em [`docs/adr/`](docs/adr/).

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

Todas as skills mantêm o `agents/openai.yaml` original do repositório-fonte (compatibilidade com outros harnesses de agente).

## Uso

Skill de brainstorm — usar `grill-me` para uma entrevista rápida, ou `grill-with-docs` quando a decisão vale a pena registrar em ADR/glossário.

Skill de referência — consultar `writing-great-skills` sempre que uma nova skill for criada neste plugin.

## Próximos passos

Criar as skills e agentes específicos de cada bloco (planejamento, desenvolvimento, testes/review, debug, finalização, prototipagem), usando `writing-great-skills` como guia de estilo.
