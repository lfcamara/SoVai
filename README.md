# SoVai

Plugin Claude Code com um engineering workflow de uso geral — serve para qualquer projeto individual, não é atrelado a nenhum. Reúne skills e agentes organizados por bloco do processo de implementação.

## Blocos do workflow

- **Planejamento** — ✅ implementado
- **Prototipagem** — ✅ implementado
- **Desenvolvimento** — implementação guiada (TDD, domain modeling)
- **Testes e review** — code review, estratégia de testes
- **Debug** — diagnóstico e correção de bugs
- **Finalização de trabalho** — handoff, checklist de conclusão

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
| [`to-prd`](skills/planning/to-prd/SKILL.md) | Planejamento | `docs/planning/<slug>/prd.md` — problema, solução, user stories, em linguagem de negócio |
| [`to-spec`](skills/planning/to-spec/SKILL.md) | Planejamento | `docs/planning/<slug>/spec.md` — decisões de implementação, seams de teste, escopo técnico |
| [`to-wireframes`](skills/prototyping/to-wireframes/SKILL.md) | Prototipagem | `docs/planning/<effort>/wireframes.md` + artifact HTML — todas as telas e os fluxos, em baixa fidelidade de propósito |
| [`to-phases`](skills/planning/to-phases/SKILL.md) | Planejamento | `docs/planning/<slug>/roadmap.md` — fases que entregam valor isoladamente (teste do cancelamento) |
| [`prototype`](skills/prototyping/prototype/SKILL.md) | Prototipagem | Protótipo descartável — variações de UI para escolher, ou modelo de estado para dirigir na mão |
| `frontend-design` | — | Design visual final. Skill ambiente, não é deste plugin — apenas apontamos para ela |
| [`to-tickets`](skills/planning/to-tickets/SKILL.md) | Planejamento | Tickets tracer-bullet no tracker (Linear por padrão) |

Todas as skills são model-invoked: é o que permite uma alcançar a outra. Skill user-invoked não pode ser chamada por outra skill.

Tudo que um esforço produz vive em `docs/planning/<effort>/`. O `to-prd` nomeia o diretório; toda etapa seguinte o resolve a partir do filesystem — é o que permite retomar uma fase semanas depois, em sessão limpa.

Decisões de design registradas em [`docs/adr/`](docs/adr/) — vale ler antes de mexer no pipeline.

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
