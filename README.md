# SoVai

Plugin Claude Code com o engineering workflow usado para desenvolver o app SoVai (mobile). Reúne skills e agentes organizados por bloco do processo de implementação.

## Blocos do workflow (em construção)

- **Planejamento** — definição de escopo, specs, decisões de arquitetura
- **Desenvolvimento** — implementação guiada (TDD, domain modeling)
- **Testes e review** — code review, estratégia de testes
- **Debug** — diagnóstico e correção de bugs
- **Finalização de trabalho** — handoff, checklist de conclusão
- **Prototipagem** — exploração rápida de UI/fluxos

Cada bloco vai ganhar suas próprias skills conforme o projeto avança. As duas skills abaixo são a base sobre a qual as demais serão construídas.

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
