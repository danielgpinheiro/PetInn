import tippy, { animateFill } from 'tippy.js'

const tooltip = {
	mounted() {
		initTooltip()
	},
	updated() {
		initTooltip()
	}
}

const initTooltip = () => {
	tippy("[data-tippy-content]", {
		animateFill: true,
		plugins: [animateFill],
	});
}

export default tooltip