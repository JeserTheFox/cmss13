import { Fragment } from "inferno";
import { useBackend, useLocalState } from '../backend';
import { Input, Button, Flex, Section, Tabs, Box, Dropdown, Slider, Tooltip } from '../components';
import { FlexItem } from '../components/Flex';
import { Window } from '../layouts';

const PAGES = [
  {
    title: 'Camouflage Paintjobs',
    component: () => Camoufalge,
    color: "green",
  },
  {
    title: 'Custom Paintjobs',
    component: () => Custom,
    color: "green",
  },
  ];

export const SprayGun = (props, context) => {
  const { act, data } = useBackend(context);
  const { current_paintjob, current_map, glob_paintjobs, playtime } = data;
  const PageComponent = PAGES[pageIndex].component();
  
  return (
    <Window
      width={360}
      height={120}
	  
    >
      <Window.Content scrollable>
        <Section>
          <Button
            fluid
            color={data.is_timing? "green" : "red"}
            icon="clock"
            content={data.is_timing? "Enabled" : "Disabled"}
            onClick={() => act("set_timing", { should_time: !data.is_timing })}
          />
        </Section>
	    <Flex fill grow>
          <Flex.Item>
            <Section fitted>
              <Tabs horizontal>
                {PAGES.map((page, i) => {
                  return (
                    <Tabs.Tab
                      key={i}
                      color={page.color}
                      selected={i === pageIndex}
                      icon={page.icon}
                      onClick={() => setPageIndex(i)}>
                      {page.title}
                    </Tabs.Tab>
                  );
                })}
              </Tabs>
            </Section>
          </Flex.Item>
          <Flex.Item
            position="relative"
            grow={1}
            basis={0}
            ml={1}
          >
            <PageComponent />
          </Flex.Item>
        </Flex>	
      </Window.Content>
    </Window>
  );
};