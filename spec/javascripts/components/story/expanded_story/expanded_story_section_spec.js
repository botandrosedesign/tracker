import React from 'react';
import { shallow } from 'enzyme';
import ExpandedStorySection from 'components/story/ExpandedStory/ExpandedStorySection';

describe('<ExpandedStorySection />', () => {
  it('renders section-title with the right text', () => {
    const title = 'my title';

    const wrapper = shallow(<ExpandedStorySection title={title} />);

    expect(wrapper.find('.Story__section-title').text()).toContain(title);
  });

  it('renders with the right identifier className', () => {
    const identifier = 'content';

    const wrapper = shallow(
      <ExpandedStorySection
        title='title'
        identifier={identifier}
      />
    );

    expect(wrapper.find(`.Story__section__${identifier}`)).toExist();
  });

  it('renders children', () => {
    const children = <div>{'children'}</div>;

    const wrapper = shallow(
      <ExpandedStorySection
        title='title'
      >
        {children}
      </ExpandedStorySection>
    );

    expect(wrapper).toContainReact(children);
  });
});
